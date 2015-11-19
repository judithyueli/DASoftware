classdef DA <handle
    % this is an abstract interface class for data assimilation subclass
    % list all properties and functions shared by the concrete subclass of DA
    properties
        n; % number of measurements
        m; % number of unknowns
        loc; % location of the particles
        kernel; % kernel, a function handle
        x; % state mean
        nt; % total assimilation step
        K; % Kalman gain
        t_assim; % assimilation step count
        t_forecast;% forecast step count    
    end    
    methods (Abstract)
        predict(obj,fw);
        update(obj,fw);
    end
    
end