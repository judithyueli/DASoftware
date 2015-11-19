classdef FW <handle
    % Abstract interface for all forward model subclass
    % list all properties and methods shared in the FW subclass (concrete)
    properties
        model = '';
        m = [];
        n = [];
        H = [];
        F = [];
        x = [];
        loc = [];
    end
    methods (Abstract)
        y = h(obj,x); % measurement function
        x = f(obj,x); % forward model
    end
end
