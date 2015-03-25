classdef DA <handle
    % super class of data assimilation subclass
    % methods and functions shared by the subclass of DA
    properties
        method = 'CSKF';
        m = [];
        kernel = []; % kernel
        fwcase = []; % instance of model
        obsstd = []; % standard deviation of observation
    end
    
    methods
        function da1 = DA(obj,case1,param)
            % constructor: copy parameters from user specified param
            % da1 is an instance of DA superclass
            obj.method = param.method;
            obj.kernel = param.kernel;
            obj.obsstd = 0.4*ones(case1.n,1);
            switch obj.method
                case KF
                    da1 = KF(case1); % illegal
                otherwise %add your own method class
                    error('method does not exit');
            end
        end
    end
    
end