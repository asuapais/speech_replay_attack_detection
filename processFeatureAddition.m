clear; close all; clc;

dir = './';

genuineFeatureCellDev = addNewFeature(dir,'genuineFeatureCellDev','snrOriginalDEV', 'excessOriginalDEV', 'sigmaOriginalDEV', 'rangeOriginalDEV' );
save ('./cqcc_and_4feature/genuineFeatureCellDev.mat', 'genuineFeatureCellDev','-v7.3');

genuineFeatureCellTrain = addNewFeature(dir,'genuineFeatureCellTrain','snrOriginalTRAIN', 'excessOriginalTRAIN','sigmaOriginalTRAIN', 'rangeOriginalTRAIN' );
save ('./cqcc_and_4feature/genuineFeatureCellTrain.mat', 'genuineFeatureCellTrain','-v7.3');

spoofFeatureCellDev = addNewFeature(dir,'spoofFeatureCellDev','snrSpoofDEV', 'excessSpoofDEV','sigmaSpoofDEV', 'rangeSpoofDEV' );
save ('./cqcc_and_4feature/spoofFeatureCellDev.mat', 'spoofFeatureCellDev','-v7.3');

spoofFeatureCellTrain = addNewFeature(dir,'spoofFeatureCellTrain','snrSpoofTRAIN', 'excessSpoofTRAIN','sigmaSpoofTRAIN','rangeSpoofTRAIN' );
save ('./cqcc_and_4feature/spoofFeatureCellTrain.mat', 'spoofFeatureCellTrain','-v7.3');


evaluationFeature = addNewFeature(dir,'evaluationFeature','snrEVA', 'excessEVA','sigmaEVA', 'rangeEVA' );
save ('./cqcc_and_4feature/evaluationFeature.mat', 'evaluationFeature','-v7.3');