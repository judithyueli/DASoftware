function [U,Gain] = EnKF (D, Y, A, scheme, R, tol, beta)
%----------------------------------------------------------------------------------
% SYNOPSIS:
%   function U = EnKF (D, Y, A, scheme, R, tol, beta)
%
% DESCRIPTION:
%   Various EnKF update schemes following Evensen (2009).
%
% PARAMETERS:
%   D           -   ensemble of simulated measurements
%   Y           -   ensemble of perturbed measurements
%   A           -   ensemble of simulated states
%   scheme      -   EnKF scheme: 1 inverse computed using Matlab functions \ and / 
%                                  and full rank R
%                                2 pseudo inverse of C with full rank R
%                                3 subspace pseudo inverse of C with low
%                                  rank Re (default)
%   R           -   vector with measurement error variances
%   tol         -   tolerance used in pseudo inversion (default: 0.01)
%   beta        -   step size (default: 1)
%
% RETURNS:
%   Updated ensemble of model states U
%
%
%{
  Copyright 2012, 2013, TNO, Petroleum Geosciences.

  This file is part of the EnKF module for MRST. 

  The EnKF module is free software. You can redistribute it and/or modify it under 
  the terms of the GNU General Public License as published by the Free Software 
  Foundation, either version 3 of the License, or (at your option) any later version.
 
  The EnKF module is distributed in the hope that it will be useful, but WITHOUT 
  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR 
  A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
  You should have received a copy of the GNU General Public License along with this 
  code.  If not, see <http://www.gnu.org/licenses/>.
%}
%
% The code has been tested with Matlab version R2011a.
%
% Please acknowledge TNO in any reports or publications that use the EnKF module. 
% TNO welcomes any feedback or improvements to the code.
%
% Written by Olwijn Leeuwenburgh, TNO, 2013.
%----------------------------------------------------------------------------------

if  nargin < 7, beta = 1.0; end
if  nargin < 6, tol = 0.01; end
if  nargin < 4, scheme = 3; end
if (scheme ~=3 && (nargin < 5 || isempty(R)))
    error('*** EnKF: inconsistent input specification ***')
end

% *** this line only needed as long as diagonal R is assumed ***
R = diag(R);

% number of state variables and ensemble size
ns = size(A,1);
ne = size(A,2);

% measurements
y = mean(Y,2);
m = numel(y);

Gain = zeros(ns,m); %ju

% ensemble of measurement perurbations
E = Y - repmat(y,1,ne);

% simulated measurement anomaly matrix
S = D-repmat(mean(D,2),1,ne);

if m == 1 % use scalar inverse in case of single measurement
    
    if scheme == 3
        % LOW RANK R
        C = (S*S' + E*E')/(ne-1);
    else
        % FULL RANK R
        C = S*S'/(ne-1) + R;
    end
    U = A + beta * sqrt(ne-1).\((A - repmat(mean(A,2),1,ne)) * S')*((Y - D)/C);

else % more than one measurement
    
    % INVERSE WITH \ AND / AND FULL RANK R
    if scheme == 1
                   
        S = S / sqrt(ne-1);
        if m <= ne
            C = S*S' + R;
            W = S' / C;
        else
            W = (eye(ne) + (S'/R)*S)  \ S'/R;
        end
        Gain = beta * sqrt(ne-1).\(A - repmat(mean(A,2),1,ne))*W; %ju
        U = A + Gain*(Y-D);%ju
%         U = A + beta * sqrt(ne-1).\(A - repmat(mean(A,2),1,ne))*(W*(Y - D));
        
    else
    
      % EXPLICIT PSEUDO INVERSE WITH FULL RANK R
      if scheme == 2
        
        C = S*S' + (ne-1)*R; % assumes diagonal R
        [U, Z] = eig(C);
        s0 = 0;
        for i = 1 : m
           s0 = s0 + Z(i,i);
        end
        s1 = 0.0; n = 0;
        for i = m: -1 : 1 % Z(m,m) contains largest eigenvalue
           if (s1/s0 < 1-tol) && Z(i,i) > 0.0
               n = n + 1;
               s1 = s1 + Z(i,i);
               Z(i,i) = 1.0/Z(i,i);
           else
               Z(i,i) = 0.0;
           end
        end
        
        % inverse of C
        C = U * Z * U';
        
      end
    
      % SUBSPACE PSEUDO INVERSE SCHEME FOR LOW RANK R
      if scheme == 3

        % SVD: S = U0 * Z0 * V0'
        p0 = min(m,ne);
        [U0,Z0,~] = svd(S,'econ'); % Z0: p0 x p0, U0: m x p0
        s0 = 0;
        for i = 1 : p0
           s0 = s0 + Z0(i,i);
        end
        s1 = 0.0; n = 0;
        for i = 1 : p0
           if (s1/s0 < 1-tol) && Z0(i,i) > 0.0
               n = n + 1;
               s1 = s1 + Z0(i,i);
               Z0(i,i) = 1.0/Z0(i,i);
           else
               Z0(i,i) = 0.0;
           end
        end

        % construct X0
        X0 = Z0 * U0' * E; % X0: p0 x ne

        % SVD: X0 = U1 * Z1 * V1'
        p1 = min(p0,ne);
        [U1,Z1,~] = svd(X0,'econ'); % Z1: p1 x p1, U1: p0 x p1
        s0 = 0;
        for i = 1 : p1
           s0 = s0 + Z1(i,i);
        end
        s1 = 0.0; n = 0;
        for i = 1 : p1
           if (s1/s0 < 1-tol) && Z1(i,i) > 0.0
               n = n + 1;
               s1 = s1 + Z1(i,i);
               Z1(i,i) = 1.0/(Z1(i,i)^2+1.0);
           else
               Z1(i,i) = 1.0;
           end
        end

        % construct X1
        X1 = U0 * Z0' * U1; % X1: m x p1

        % inverse of C
        C = X1 * Z1 * X1'; % C: m x m
        
      end
      
      % ensemble update for pseudo inverse schemes
      if (2*ns*m*ne < (ns+m)*ne^2)
        % few measurements
        U = A + beta * ((A - repmat(mean(A,2),1,ne)) * S') * (C * (Y - D));
      else      
        % many measurements
        U = A * (eye(ne) + beta * S' * C * (Y - D));
      end
      
    end

end
