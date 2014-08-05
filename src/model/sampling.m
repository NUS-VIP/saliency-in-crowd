function [X Y] = sampling(params, trainingImgs, features)
% [X Y] = sampling(params, trainingImgs, features)
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

numtraining = length(trainingImgs);
posPtsPerImg=10; % number of positive samples taken per image to do the learning
negPtsPerImg=10; % number of negative samples taken
p=20; % pos samples are taken from the top p percent salient pixels of the fixation map
q=40; % neg samples are taken from below the top q percent

H = params.out.height;
W = params.out.width;
featuresTraining = collectFeatures(params, trainingImgs, features); % this should be size [M*N*numImages, numFeatures]
labels = zeros(length(trainingImgs) * H * W, 1);

for i = 1 : length(trainingImgs)
    index = (i - 1) * (H * W);
    fileName = trainingImgs{i};
    map = im2double(imread(fullfile(params.path.maps.fixation, fileName)));
    map = imresize(map, [H W]);


    labels(index + 1:index + H * W, 1) = map(:);
end    

[posIndices, negIndices] = selectSamplesPerImg(labels, p, q, numtraining, [H W], posPtsPerImg, negPtsPerImg);
X = double(featuresTraining([posIndices, negIndices], :)); %trainingFeatures
Y = double([ones(1, length(posIndices)), zeros(1, length(negIndices))])'; %trainingLabels

