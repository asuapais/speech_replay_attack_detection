
clear; close all; clc;

% add required libraries to the path
addpath(genpath('utility'));
addpath(genpath('CQCC_v1.0'));
addpath(genpath('bosaris_toolkit'));

% set paths to the wave files and protocols
dir = 'N:\Science\Antispoofing Research (ipython notebook)\asvspoof2017-submission\';
pathToDatabase = fullfile(dir,'ASVspoof2017_train_dev','wav');
trainProtocolFile = strcat(dir,'protocol\ASVspoof2017_train.trn');
devProtocolFile = strcat(dir,'protocol\ASVspoof2017_dev.trl');

genuineFeatureCellTrain = load('./cqcc_and_4feature/genuineFeatureCellTrain.mat');
genuineFeatureCellDev = load('./cqcc_and_4feature/genuineFeatureCellDev.mat');
spoofFeatureCellDev = load('./cqcc_and_4feature/spoofFeatureCellDev.mat');
spoofFeatureCellTrain = load('./cqcc_and_4feature/spoofFeatureCellTrain.mat');

%% GMM training

% train GMM for GENUINE data
disp('Training GMM for GENUINE...');
[genuineGMM.m, genuineGMM.s, genuineGMM.w] = vl_gmm([genuineFeatureCellTrain.genuineFeatureCellTrain{:}], 512, 'verbose', 'MaxNumIterations',100);
disp('Done!');

% train GMM for SPOOF data
disp('Training GMM for SPOOF...');
[spoofGMM.m, spoofGMM.s, spoofGMM.w] = vl_gmm([spoofFeatureCellTrain.spoofFeatureCellTrain{:}], 512, 'verbose', 'MaxNumIterations',100);
disp('Done!');


%% Feature extraction and scoring of development data

% read development protocol
fileID = fopen(devProtocolFile);
protocol = textscan(fileID, '%s%s%s%s%s%s%s');
fclose(fileID);

labels = protocol{2};

genuineFeatureCellDev = load('./cqcc_and_4feature/genuineFeatureCellDev.mat');
spoofFeatureCellDev = load('./cqcc_and_4feature/spoofFeatureCellDev.mat');
all_data = cat(1,genuineFeatureCellDev.genuineFeatureCellDev,spoofFeatureCellDev.spoofFeatureCellDev);
scores = zeros(size(labels));
%%
for i=1:length(all_data)
    llk_genuine = mean(compute_llk(all_data{i},genuineGMM.m,genuineGMM.s,genuineGMM.w));
    llk_spoof = mean(compute_llk(all_data{i},spoofGMM.m,spoofGMM.s,spoofGMM.w));
    scores(i) = llk_genuine - llk_spoof;
end

disp('Done!');

%% compute performance
[Pmiss,Pfa] = rocch(scores(strcmp(labels,'genuine')),scores(strcmp(labels,'spoof')));
EER = rocch2eer(Pmiss,Pfa) * 100; 
fprintf('EER is %.2f\n', EER);


%%
%%%%%%%%%%%%%%%%%%%%%% EVALUATION%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Computing scores for evaluation trials...');
evaProtocolFile = strcat(dir,'protocol\KEY_ASVspoof2017_eval_V2.trl');

%% Feature extraction and scoring of eva data

% read development protocol
fileID = fopen(evaProtocolFile);

protocol = textscan(fileID, '%s%s%s%s%s%s%s');
filenames = protocol{1};
labels = protocol{2};
fclose(fileID);

disp('Load evaluation set...');
%%
evaluationFeature = load('./cqcc_and_4feature/evaluationFeature.mat');
%%
scores = zeros(size(filenames));
%%
for i=1:length(filenames)
    llk_genuine = mean(compute_llk(evaluationFeature{i},genuineGMM.m,genuineGMM.s,genuineGMM.w));
    llk_spoof = mean(compute_llk(evaluationFeature{i},spoofGMM.m,spoofGMM.s,spoofGMM.w));
    scores(i) = llk_genuine - llk_spoof;
end

%% compute performance
[Pmiss,Pfa] = rocch(scores(strcmp(labels,'genuine')),scores(strcmp(labels,'spoof')));
EER = rocch2eer(Pmiss,Pfa) * 100; 
fprintf('EER is %.2f\n', EER);
