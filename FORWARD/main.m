% main
clear all;
clc;
close all;
% function [sol,stats] = main(filename)
% input: filename of input selected by users

% Convert information from txt into a structure param
% param = readINFILE(filename);
param.model = 'Saetrom';
param.method = 'KF';
param.x_std = 20;
param.kernel = @(h) param.x_std.*exp(-(h./(20/3)));
param.obsstd = 1; % observation STD
param.nt = 10; % total data assimilation step
% TODO: add other parameters specifed by users:
% total simulation step

%% Initialization
% Map simulation parameters to FW subclass and create an object at time 0
fw = selectFW(param);
file = load('ini.mat');
fw.xt = file.xt;
% Map inversion parameters to DA subclass and create an object at time 0
da = selectDA(param,fw);

% TODO: check if fw and da contain all the necessary properties and functions after initialization
rng(100);
% for each data asismilation step
for i = 1:1
    %% Run truemodel to produce true state xt and data z, save as property of fw
    % call f and h to update state and observation
    fw.step = i; % mandatory for Saetrom case
    fw.xt = fw.f(fw.xt);
    fw.zt = fw.h(fw.xt);
    noise = fw.zt_std*randn(size(fw.zt));
    fw.zt = fw.zt + noise;
    
    %% Run data assimilation to get solution x and its uncertainty, save as property of da
    % KF forecast
    da.t_forecast = i;
    da.predict(fw);
    
    % KF predict
    da.t_assim = i;
    da.update(fw,fw.zt);
    
    % save fw and da as snapshots for analysis
end

% clear da
% clear fw