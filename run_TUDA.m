% It needs the HMM-MAR toolbox, which can be forked from here: 
% https://github.com/OHBA-analysis/HMM-MAR

mydir = '~/MATLAB/';
addpath(genpath([ mydir 'HMM-MAR']))
load('data/subj9_sess1.mat')

% Put the angle (in radians) into a (Sin,cos)-spatial basis
Y = [sin(y) cos(y)];
Y = Y - repmat(mean(Y),size(Y,1),1);
ttrial = T(1); N = length(T); 

K = 4; % number of decoders 
Npca = 48; % PCA components to base the prediction on 

options = struct();
options.K = K;
options.pca = Npca; 
options.DirichletDiag = 1000;
options.detrend = 1; % do detrending in the data
options.onpower = 0 ; % run on raw signal
options.standardise = 1; % standardize data
options.parallel_trials = 1; % trials are aligned (to stimulus presentation)
options.tol = 1e-5;
options.cyc = 100; % a bit quicker than by default
options.initcyc = 10;
options.initrep = 3;
options.verbose = 1;

% Train tuda
[tuda,Gamma,GammaInit] = tudatrain(data,Y,T,options);
% Encoding model
encmodel = tudaencoding(data,Y,T,options,Gamma);

save('out/subj9_sess1.mat','tuda','Gamma','encmodel','GammaInit')



