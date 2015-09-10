classdef Frio < handle
    %{
    A 2D data assimilation example. Data sets cosist of true CO2 simulation results
    at three different resolution (low,medium,high) that users can choose from.
    Observations are 288 travel-time delay (ms) at 41 time steps.
    %}
    properties
        nt;         % number of assimilation step
        x_true_list % a cell of x vector for each time step
        y_true_mtx  % a matrix containing true observation
        step;       % max = 41
        m;         % scalar, state dimension
        n;         % scalar, observation dimension
        F;          % transition matrix
        H;          % measurement matrix
        QHT;        % model error cross-covariance
        resolution; % low/medium/large
        x_loc;
        y_loc;
        loc;       % m x dim matrix, grid block coordinates
        xt;         % structure
        % xt.vec: m x 1 vector, current state
        % xt.t: scalar, current time
        zt;         % n x 1 vector, current observation
        nt_max = 41;% maximum step
        output_slice; % output time steps
        obsvar;
        kernel;     % kernel for model error covariance Q
    end
    methods
        function obj = Frio(param)
            % read data files
            obj.n = 288;
            obj.nt = param.nt;
            obj.resolution = param.resolution;
            obj.kernel = param.kernel;
            
            switch obj.resolution
                case 'low'
                    file = load('./data/Res1.mat');
                    obj.m = 59*55;
                case 'medium'
                    file = load('./data/Res2.mat');
                    obj.m = 117*109;
                case 'high'
                    file = load('./data/Res3.mat');
                    obj.m = 234*217;
            end
            
            % load simulation results
            obj.x_true_list = cell(obj.nt_max,1);
            for i = 1:obj.nt_max
                tm = file.truemodel{i};
                obj.x_true_list{i} = tm(:);
            end
            
            % load grid information
            x_loc = file.xc;
            y_loc = file.yc;
            [X,Y] = meshgrid(x_loc,y_loc);
            obj.loc = [X(:) Y(:)];
            obj.x_loc = x_loc;
            obj.y_loc = y_loc;
            
            % load sensor measurement operator and measurements
            obj.H = file.H;
            obj.F = eye(obj.m,obj.m);
            obj.QHT = file.M1;
            obj.y_true_mtx = file.data65;
            obj.obsvar = 1;
            
            % initialize state
            obj.xt = obj.getx();
            
            % plot info
            obj.output_slice = param.output_slice;
            assert(max(obj.output_slice)<=obj.nt);
        end
        
        function [x,z] = simulate(obj,x)
            % simulate 1-step true process
            % output:
            %   x: next state
            %   y: next observation
            try
                x.t = x.t+1;
                x.vec = obj.x_true_list{x.t+1};
                z = obj.y_true_mtx(:,x.t+1);
                obj.xt = x;
                obj.zt = z;
            catch err
                fprintf('index for x_true_list %d exceeds the maximum %d\n',x.t+1,obj.nt_max)
                rethrow(err);
            end
        end
        
        function x = f(obj,x)
            % forecast state using random walk model
            x.t = x.t+1;
            x.vec = x.vec;
        end
        
        function y = h(obj,x)
            % forecast observation
            y = obj.H*x.vec;
        end
        
        function x = getx(obj)
            % initialize x at time 0
            x.t = 0;
            x.vec = obj.x_true_list{x.t+1};
        end
        
        function visualize(obj, fw_list, da_list)
            %% Plot results
            switch obj.resolution
                case 'low'
                    crosswell = 18:43;
                    nx = 59;
                    ny = 55;
                case 'medium'
                    crosswell = 34:84;
                    nx = 117;
                    ny = 109;
                case 'high'
                    crosswell = 67:167;
                    nx = 234;
                    ny = 217;
                otherwise
                    Error('resolution must be low,medium or high')
            end
            xwell = obj.x_loc(crosswell);
            ywell = obj.y_loc;
            
            figure;
            i = 1;
            for k = 1:4
                nsubfigure = length(obj.output_slice);
                for j = obj.output_slice %linspace(2,nt,4)
                    switch k
                        case 1 % true mean
                            clims = [-1.27 6.3]*1e-1;
                            x_image = fw_list{j}.xt.vec;
                        case 2 % estimated mean
                            clims = [-1.27 6.3]*1e-1;
                            x_image = da_list{j}.x.vec;
                        case 3 % variance
                            clims = [2 12].*1e-9;
                            x_image = da_list{j}.variance;
                        case 4 % Kalman gain
                            clims = [-2.1 6.3].*1e-4;
                            x_image = da_list{j}.K(:,20);
                        otherwise
                            error('error');
                    end
                    subplot (4,nsubfigure,i)
                    %     imagesc(xwell,ywell,xtruewell{j},clims)
                    x_image = reshape(x_image,ny,nx);
                    x_image = x_image(:,crosswell);
%                     imagesc(xwell,ywell,x_image,clims)
                    imagesc(xwell,ywell,x_image)
                    % imagesc(xwell,ywell,xestwell{j})
                    %             imagesc(xwell,ywell,pstvar{j})
                    %imagesc(xc,yc,truemodel{j},clims)
                    title ([num2str(j*3),' hours'])
                    axis image
                    colorbar
                    % title 'true model'
                    i=i+1;
                end
            end
        end
    end
    
    methods
        da = initializeSSM(obj,da);
        % initialize state space model(SSM) of Frio for a given filter
        % type (KF,HiKF,CSKF)
    end
end