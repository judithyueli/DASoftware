% function [prm, fmt] = get_prmstruct(prm)
%
% Creates two structures: prm -- to hold the system parameters; and fmt -- to
% hold the format strings for each parameter, used while reading from a file
%
% @param prm - system parameters (optional)
% @return prm - system parameters
% @return fmt - parameter formats
%
% Description of individual fields in the parameter file:
%
% field = method
%   - assimilation method
%   values =
%     KF
%     CSKF
%     SpecKF
%     HiKF
%     CSKS
%     ENKF
%
% field = model
%   - model tag
% values =
%   SA   - Saetrom model
%   LA   - linear advection model
%   LA2  - linear advection model (2 variables)
%   
%
%   MRST - non-linear multiphase model
%
% field = m
%   - the model state vector length for each variable being estimated; 
%   values =
%     <number>
%
% field = multi
%   - for multi-variate models
%   - the number of variables/parameters being estimated; 
%   - e.g. if we are simultanetously estimating pressure and permeability p=2
%   values =
%     <number>
%
% field = N
%   - number of basis used for low-rank methods
%   values =
%     <number>
%
% field = BasisType
%    - Compression method used for low rank covariance
%    values = 
%       SVD
%       randSVD
%
%
% field = n
%   - 
%   values = the number of observations for each type 
%   - to be adjusted later for multiple types of observations;
%     <number>
%
% field = nt
%   - number of assimilation steps
%   values =
%     <number>
%
%
% field = x_std
%   - state standard deviation
%   values =
%     <number>
%
% field = obsstd
%   - observation standard deviation
%   values =
%     <number>
%
%
% field = cov_function
%   - state covariance function kernel
%   values =
%     exponential
%     gaussian
%     linear
%
% field = cor_length
%   - state covariance correlation length
%   values =
%     <number>
%
%
% field = seed
%   - initial seed for the random number generator; only if randomise = 0
%   values =
%     <number (0*)>
%
%
% field = enkfmatlabdir
%   - location of the EnKF-Matlab code
%   values =
%     <dir name>
%
% field = version
%   - version string of the EnKF-Matlab code
%   values =
%     <none>
%
%

% File:           get_prmstruct.m
%
% Created:        31/08/2007 by Pavel Sakov, CSIRO Marine and Atmospheric
% Research, NERSC
%
% Last modified:  30/03/2015
%
%
% Purpose:        Creates two structures: prm -- to hold the system parameters;
%                 and fmt -- to hold the format strings for each parameter,
%                 used while reading from a file
%
% Description:    
%
% Revisions:      3.29.2015 AK: Created  test case for Saetrom case
%                 

%% Copyright (C) 2008 Pavel Sakov
%% .

function [prm, fmt] = get_prmstruct(prm)

    if ~exist('prm', 'var') % temporary assignment of values to structure prm
        prm = struct(                       ...
            'method',          {'KF'},      ...
            'model',           {'Saetrom'}, ...
            'm',               {0},         ...
            'multi',           {1},         ...
            'N',               {20},         ...
            'BasisType',       {'SVD'},     ...
            'n',               {0},         ...
            'nt',              {0},         ...
            'x_std',           {20},        ...
            'obsstd',          {1},         ...
            'cov_function',    {'Exponent'},...
            'cor_length',      {6},         ...
            'seed',            {0},         ... 
            'parentdir',       {'./'},      ... 
            'version',         {0.0}        ... 
            );
    end
  
    fmt = struct(                           ...
            'method',          {'%s'},      ...
            'model',           {'%s'},      ...
            'm',               {'%d'},      ...
            'multi',           {'%d'},      ...
            'N',               {'%d'},      ...
            'BasisType',       {'%s'},      ...
            'n',               {'%d'},      ...
            'nt',              {'%d'},      ...
            'x_std',           {'%g'},      ...
            'obsstd',          {'%g'},      ...
            'cov_function',    {'%s'},      ...
            'cor_length',      {'%d'},      ...
            'seed',            {'%d'},      ... 
            'parentdir',       {'%s'},      ... 
            'version',         {'%g'}       ... 
            );
  
    return
