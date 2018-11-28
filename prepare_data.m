% This file prepares the data, which is in a fieldtrip object, 
% into the matrices that are included in Github (of much more amenable
% size). The original files were not included in this repository but can be
% found at 
% http://datasharedrive.blogspot.com/2015/08/testing-sensory-evidence-against.html

isession = 1; isub = 9;

% This directory is not contained in the present folder. 
% Please download the corresponding files from
% http://datasharedrive.blogspot.com/2015/08/testing-sensory-evidence-against.html
datadir = 'TUDA_DIR/';

% load data
load([datadir '/S09_MEG.mat']) % contains a ft Fieldtrip object

ichan = 1:306; % check that there are 306 and then remove
time_pre_stimulus = 0; 

twin = [0  0.6]; % time of interest
it = ft.time{1} >= twin(1) & ft.time{1} <= twin(2);

for itrlcur = 1:length(ft.trial) % select the channels
    ft.trial{itrlcur} = ft.trial{itrlcur}(ichan,:);
end

data = single(cat(3,ft.trial{:})); % Ntimepoints X Ntrials X 
data = permute(data,[2 3 1]); % time x trials x sensors
trialinfo = ft.trialinfo;

data = data(it,:,:);
data = data.*(10.^14);
[ttrial,N,p] = size(data);

% checking good trials
good_trials = true(N,1);
for j1=1:N
    d = permute(data(:,j1,:),[1 3 2]);
    v = var(d);
    good_trials(j1) = all(~isnan(v)) && all(v>0);
end
data = data(:,good_trials,:);
T = ttrial * ones(N,1); 

% response 
y = ft.trialinfo(good_trials,4); % relative angle information 
y = y*pi*2/180;
y = mod(y + pi, pi*2) - pi;
Y = [sin(y) cos(y)];
Y = Y - repmat(mean(Y),size(Y,1),1);

save('data/subj9_sess1.mat','data','T','y','good_trials')

clear ft

