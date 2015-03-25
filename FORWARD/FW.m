classdef FW <handle
    % Forward model superclass
    % Methods and functions shared in the FW subclass
    properties
        model = '';
        m = [];
        n = [];
        H = [];
        F = [];
        x = [];
        loc = [];
    end
    
    methods
        function obj = FW(param)
            % obj is an instance of FW class
            obj.model = param.model;
            switch obj.model
                case Saetrom
                    obj = Saetrom(); % illegal
                otherwise %add your own class
            end
        end
    end
end
