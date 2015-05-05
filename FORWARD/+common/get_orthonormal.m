function QQ = get_orthonormal(m,n)
% Produces an m x n set of orthonormal vectors, 
% (thats n vectors, each of length m)
% 
% Inputs should be two scalars, m and n, where n is smaller than 
% or equal to m.
%
% Reference: Evensen, G. (2009). Data Assimilation: The Ensemble Kalman Filter (2nd ed., pp. 1?279). Berlin, Heidelberg: Springer. doi:10.1007/978-3-642-03711-5_BM2  page 169
% Example: >> get_orthonormal(5,4)
%
% ans =
%     0.1503   -0.0884   -0.0530    0.8839
%    -0.4370   -0.7322   -0.1961   -0.2207
%    -0.3539    0.3098    0.7467   -0.0890
%     0.7890   -0.1023    0.0798   -0.3701
%    -0.1968    0.5913   -0.6283   -0.1585



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% CHECK USER INPUT
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if ( (nargin==2) && (m>=n) && (isnumeric(m)*isnumeric(n)) )
    
elseif ( nargin==1 && isnumeric(m) && length(m)==1 )
    
    n=m;
    
else
   error('Incorrect Inputs. Please read help text in m-file.')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% GENERATE ORTHORNORMAL VECTORS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% step 1: QR of a random matrix Y
Y = randn(m);
[Q,R] = qr(Y);
% step 2: Generate a diagonal matrix with -1 or 1
diagR = diag(R);
Z = diag(diagR./abs(diagR));
% step3: a random orthogonal matrix QQ
QQ = Q*Z;

% step4: extract the first n rows of QQ
QQ = QQ(1:n,:);

% % method 2
% count=0;
% while (count==0)
% 
%     % generate an mxm matrix A, then make a symmetric mxm matrix B
%     A=rand(m);
%     B=A'*A ;
% 
%     % now take the eigenvectors of B, 
%     % eigenvectors from different eigenspaces (corresponding to different
%     % eigenvalues) will be orthogonal
% 
%     % there is a chance that there will be repeat eigenvalues, which would give
%     % rise to non-orthogonal eigenvectors (though they will still be independent)
%     % we will check for this below
%     % if this does happen, we will just start the loop over again 
%     % and hope that the next randomly created symmetric matrix will not
%     % have repeat eigenvalues,
%     % (another approach would be to put the non-orthogonal vectors
%     % through the gram-schmidt process and get orthogonal vectors that way)
% 
%     % since matlab returns unit length eigenvectors, they will also be
%     % orthonormal
% 
%     [P,D] = eig(B) ;
% 
%     % can double check the orthonormality, by taking the difference between 
%     % P'P and I, if it is non-zero, then there is an error (caused by repeat
%     % eigenvalues), repeat the loop over again
% 
%     if ((P'*P - eye(m))>eps) 
%         % error, vectors not orthonormal, repeat the random matrix draw again
%         count=0
%     else
%         % we want the first n of these orthonormal columns
%         answer=P(:,1:n) ;
%         count=1;
%     end

end