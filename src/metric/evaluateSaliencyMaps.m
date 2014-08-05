function [aucPerf, nssPerf, ccPerf, roc] = evaluateSaliencyMaps(params, split)
% [aucPerf, nssPerf, ccPerf, roc] = evaluateSaliencyMaps(params, split)
%
% ----------------------------------------------------------------------
% Matlab tools for "Saliency in crowd," ECCV, 2014
% Ming Jiang, Juan Xu, Qi Zhao
%
% Copyright (c) 2014 NUS VIP - Visual Information Processing Lab
%
% Distributed under the MIT License
% See LICENSE file in the distribution folder.
% -----------------------------------------------------------------------

load(fullfile(params.path.data, 'splits.mat'));
testingImgs = splits(split).files.test;
nImgs = length(testingImgs);
nssPerf = nan(1, nImgs);
aucPerf = nan(1, nImgs);
ccPerf = nan(1, nImgs);
roc = cell(1, nImgs);

shufMap = im2double(imread(fullfile(params.path.data, 'shuffle_map.png')));

for i=1:nImgs
    fileName = testingImgs{i};
    
    fixMap = im2double(imread(fullfile(params.path.maps.fixation, fileName)));
    file = fullfile(params.path.maps.saliency, fileName);
    if ~exist(file, 'file')
        continue;
    end
    map = im2double(imread(file));
    map = imresize(map, size(fixMap));
    
    % get the fixation points
    load(fullfile(params.path.maps.fixation, fileName(1:end-4)));
    nssPerf(i) = mean(calcNSSscore( map, fixationPts ));
    ccPerf(i) = corr2(map, fixMap);
    
    [auc curves] = calcAUCscore(map, fixationPts, logical(imresize(shufMap, size(map))) & fixationPts == 0, 100);
    
    aucPerf(i) = mean(auc);
    a=cell2mat(curves);
    roc{i} = [mean(a(:,1:2:end), 2) mean(a(:,2:2:end), 2)];
end