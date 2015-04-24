classdef Saetrom < handle
    % Created on 14/03/2015 by Judith Li
    % Modified on 24/03/2015 by Judith Li
    properties
        xt = [];    % true state
        step = [];  % current step, must be within range [1,10].Note matlab index from 1 instead of 0 as in C++
        zt = [];    % true observation
    end
    
    properties(GetAccess = public,SetAccess = private)
        nstep = []; % maximum step
        m = [];     % number of unknowns
        n = [];     % number of observation
        H = [];     % measurement equation, fixed in time
        F = [];     % state transition equation, change with time
        xt_std = 20; % true state STD
        zt_std = 1; % true observation STD
        loc = [];   % m x nd matrix, location coordinates of each state variable
    end
    
    methods
        % Constructor
        function obj = Saetrom(param)
            % Check input
            % Initialize parameters by case1 = Saetrom(param);
            obj.m = 100; %param.m;
            obj.n = 13; %param.n;
            obj.step = 0;% begin from time 0
            obj.nstep = 10;
            % Construct H that is fixed in time
            obj.H = getH(obj);
            % Get geometry
            getLOC(obj);
            % Initialize state
            rng(100)
            obj.xt = obj.getx(obj.loc,param.kernel);
        end
        
        function y = h(obj,x)
            %% Observation equation
            % obj and x must reflect the correct initial condition before calling this function
            Hmtx = obj.H; % H is initialized in constructor for static case, for dynamic case use getH
            y = Hmtx*x;
            noise = obj.zt_std*randn(size(obj.zt));
            obj.zt = obj.zt + noise;
        end
        
        function x = f(obj,x)
            %% Forecast equation
            % x is the transformed unknowns used for data assimilation
            % obj is the initil condition that is not corrected by DA
            % obj.step and x must reflect the correct initial condition before calling this function
            % overload property: obj.F changes at the end of call
            if (size(x,1) ~= obj.m) || (size(x,2) ~= 1)
                error('x is not the right size');
            else
                Fmtx = getF(obj);
                x = Fmtx*x;
                obj.F = Fmtx;
                % update xt,F and step??
            end
        end
        
        function x = getx(obj,loc,kernelfun)
            % generate a random realization from N(0,Q0), where Q0 is
            % generated form kernelfun and loc. See getQ for details
            Q0 = obj.getQ(loc,kernelfun);
            [A,C,~] = svd(Q0);
            x = zeros(obj.m,1) + A*sqrt(C)*randn(obj.m,1);
        end
        
        function delete(obj)
            % destructor: do we need it?
            disp('The object from Saetrom is going to be deleted');
        end
    end
    
    methods(Static)
        function Q0 = getQ(loc,kernelfun)
            % Each column of loc saves the coordinates of each point
            % For 2D cases, loc = [x y]
            % For 3D cases, loc = [x y z]
            % np: number of points
            % nd: number of dimension
            [np,nd] = size(loc);
            h = zeros(np,np); % seperation between two points
            for i = 1:nd
                xi = loc(:,i);
                [xj,xl]=meshgrid(xi(:),xi(:));
                h = h + ((xj-xl)).^2;
            end
            h = sqrt(h);
            Q0 = kernelfun(h);
        end
    end
    
    methods(Access = private)
        function F = getF(obj)
            % Get transition matrix F, a function of step k
            % F is constructed to move 0<x<55 but 56<x<100 remains static
            F = eye(obj.m, obj.m);
            if (obj.step>=1) && (obj.step<=obj.nstep)
                k = obj.step;
            else
                error('k must be an iteger from 1 to 10');
            end
            Fin = diag([0.5 0.3*ones(1,8) 0.5],0) + ...
                diag([0.3*ones(1,8) 0.5],-1) +...
                diag([0.5 0.3*ones(1,8)],1);
            F(5*(k-1)+1:5*(k+1),5*(k-1)+1:5*(k+1)) = Fin;
        end
        
        function H = getH(obj)
            % Get measurement matrix H
            % H is fixed in time
            Hmtx = zeros(obj.n,obj.m);
            Hmtx(1,4:6) = 1;
            Hmtx(2,14:16) = 1;
            Hmtx(3,24:26) = 1;
            Hmtx(4,34:36) = 1;
            Hmtx(5,39:41) = 1;
            Hmtx(6,44:46) = 1;
            Hmtx(7,49:51) = 1;
            Hmtx(8,54:56) = 1;
            Hmtx(9,59:61) = 1;
            Hmtx(10,64:66) = 1;
            Hmtx(11,74:76) = 1;
            Hmtx(12,84:86) = 1;
            Hmtx(13,94:96) = 1;
            H = Hmtx;
        end
        
        function getLOC(obj)
            xi = (1:obj.m)';
            yi = ones(obj.m,1);
            obj.loc = [xi yi];
        end
        %         function H = getHcoordinate(obj)
        %             % get H from user input
        %         end
        
    end
    
    %     methods(Static)
    %     end
    %
end

%TODO: consider put these common functions (generate covariance or a realization
%form a kernel) outside, and use mexBBFMM or rSVD to generate realization
% function Q0 = getQ(loc,kernelfun)
% % Each column of loc saves the coordinates of each point
% % For 2D cases, loc = [x y]
% % For 3D cases, loc = [x y z]
% % np: number of points
% % nd: number of dimension
% [np,nd] = size(loc);
% h = zeros(np,np); % seperation between two points
% for i = 1:nd
%     xi = loc(:,i);
%     [xj,xl]=meshgrid(xi(:),xi(:));
%     h = h + ((xj-xl)).^2;
% end
% h = sqrt(h);
% Q0 = kernelfun(h);
% end