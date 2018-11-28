load('out/subj9_sess1.mat')
load('data/subj9_sess1.mat','T','good_trials')
colors = {[0,0,0.8],[0.2,0.7,0.2],[1,0,0],[0.8 0 0.8],[0.6 0.6 0.2]};
K = size(Gamma,2);
N = length(T); 
ttrial = size(Gamma,1)/N;
twin = [0 0.6];
t = linspace(twin(1) , twin(end), ttrial);

% Temporal information contained in the state time courses 
figure(1);clf(1) % across-trial average
Gamma = reshape(Gamma,[ttrial N K]);
meanGamma = squeeze(mean(Gamma,2));
hold on
for k = 1:K
    %h(k).FaceColor =  colors{k};
    plot(t,meanGamma(:,k),'Color',colors{k},'LineWidth',4)
end
hold off

load('../../NickMyersDecoding/behavior.mat')
keep = behavior(9,1).response(good_trials)==1;
rt = behavior(9,1).resptime(good_trials);
rt = rt(keep);
[~,ord_rt] = sort(rt,'ascend');


figure(2) % all trials
Gamma = reshape(Gamma,[ttrial*N K]);
GammaCol = zeros(N*ttrial,3);
tmp = zeros(N*ttrial,1);
for k = 1:K
    these = sum(repmat(Gamma(:,k),1,K-1) > Gamma(:,setdiff(1:K,k)),2) == K-1;
    GammaCol(these,:) = repmat(colors{k},sum(these),1);
    tmp(these)=1;
end
GammaCol = reshape(GammaCol,[ttrial N 3]);
GammaCol2 = zeros(N,ttrial,3);
for c=1:3, GammaCol2(:,:,c) = GammaCol(:,:,c)'; end
GammaCol2 = GammaCol2(ord_rt,:,:); %g = g(1:200,:,:);
%selection = sort(randperm(length(ord_rt),200));
%g = GammaCol2(keep,:,:); g = g(ord_rt,:,:); %g = g(1:200,:,:);
%g = g(selection,:,:);
image(t,1:200,GammaCol2(:,:,:))

