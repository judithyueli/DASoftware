function [param] = get_prm(fname)

% % Reads parameters from files into the prm structure
%
% @param fname - parameter file name
% @return prm - system parameters
%
% Note: the parameter file has the following format:
%
% <parameter1 tag> <parameter1 value>
% <parameter2 tag> <parameter2 value>
% ...
%
% The tag and value should be separated by spaces only; TABs are not allowed!
% For details look at get_prmstruct.m

% File:           get_prm.m
%
% Created:        3/29/2015

% Adapted from Pavel Sakov's code, CSIRO Marine and Atmospheric Research, NERSC

% 1. read main parameter file
%
[param, format] = get_prmstruct;

param.version = get_version;

param = readprmfile(fname, param, format);
    