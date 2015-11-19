function [fSol,tSol,ierror,stats] = main(INFILE)

% MAIN function for Kalman Filter software, Kitanidis group

% Main contributors: Judith Yue Li, Stanford University, Civil Eng.
%                    Hojat Ghorbanidehno, Stanford University, Mech. Eng.

% P.I.: Peter K. Kitanidis, Stanford University, Civil Eng.

% Created on: March 9, 2015 Amalia Kokkinaki, Stanford University
% Last updated on: March 9, 2015 Amalia Kokkinaki, Stanford University

% Input variables are read from file INFILE
% See documentation for details on input data

% Example usage

% [fSol,tSol,errorid,stats]=main(INFILE);

% NOTE: All Input variables are in the INFILE and depend on mode being used. See documentation.
% For each INFILE a directory is created in folder ANALYSIS where all results are stored


% ========================================================================
% STEP 0) R E A D     I N P U T
% ========================================================================

% Read input files
cd ../DATA

% following EnKF-Matlab for input and reading of parameter files

[param,dirname] = get_prm(INFILE);

% Save input files in output directory for reference

if ~exist(['../ANALYSIS/',dirname],7); mkdir(dirname); end
save(['../ANALYSIS/',dirname,'/input.mat'],'param');

cd ..


% ========================================================================
% STEP 1) I N I T I A L I Z E   S O F T W A R E 
% ========================================================================

disp([datestr(now) 'Kalman Filtering starting'])

% display main input choices
disp([datestr(now) 'Test case:' num2str(param.TCASE)])
disp([datestr(now) 'Forward model:' num2str(param.FWD)])
disp([datestr(now) 'KF method:' num2str(param.INV)])
disp([datestr(now) 'All results saved at: ANALYSIS/',dirname])
disp('-------------------------------------')

disp([datestr(now) ' clearing up screen and memory'])
disp([datestr(now) ' '])
clc; more off; clearvars -except param


% Check if input is complete

ierror=inputcheck(param);

if ierror; disp(ierror); keyboard; end;
 
% ========================================================================
% STEP 2) I N I T I A L I Z E   P R O B L E M 
% ========================================================================
cd ../INIT
disp([datestr(now),' Initializing problem ...']);

% initializes domain, measurements etc.

[domain,measurements]=InitializeMain(param);


% ========================================================================
% STEP 3) INITIALIZE COVARIANCES
% ========================================================================

disp([datestr(now),' Initializing filter ...']);

% initializes filter specific parameters e.g. covariances

[param,U,S,V]=InitializeFilter(param);

% ========================================================================
% STEP 4) G E N E R A T E    T R U E    S O L U T I O N
% ========================================================================

disp([datestr(now),' Generating true state  ...']);

% generate_solution produces mat files that hold the full solution, iSol
% and tObs. generate_solution calls the forward model

[tSol,tobs]=ForwardMain(param,domain,measurements);

% ========================================================================
% STEP 5) KALMAN FILTER
% ========================================================================

cd ../KFILTER

disp([datestr(now),' Kalman Filter started  ...']);

for ti=1:param.ntimes
    
    disp([datestr(now),' Dataset ',num2str(ti),' being assimilated...']);
    
    [fSol,fobs] = KalmanFilterMain(param);
      
end


% ========================================================================
% STEP 6) ANALYSIS AND PLOTTING
% ========================================================================

cd ../ANALYSIS
disp([datestr(now),' Kalman Filter finished. Analysing results  ...']);


% Calculate statistics

stats = statistics(fSol,fobs,tSol,tobs);


% Generate plots if param.plotflag==1

if param.plotflag; plotting(fSol,fobs,tSol,tobs,stats); end

cd ..
close all
end

disp([datestr(now),' Program is complete.']);
disp([datestr(now),' Check folder /ANALYSIS/' dirname 'for results.']);


% ========================================================================
% END
% ========================================================================


