function trainModel(params, split)
% trainModel(params)
%
% ----------------------------------------------------------------------
% Matlab tools for "Predicting human gaze beyond pixels," Journal of Vision, 2014
% Juan Xu, Ming Jiang, Shuo Wang, Mohan Kankanhalli, Qi Zhao
%
% Copyright (c) 2014 NUS VIP - Visual Information Processing Lab
%
% Distributed under the MIT License
% See LICENSE file in the distribution folder.
% -----------------------------------------------------------------------

features = {'color', 'intensity', 'orientation', 'size', 'density', 'frontal', 'profile'};

load(fullfile(params.path.data, 'splits.mat'));
load(fullfile(params.path.data, 'stats.mat'));

trainingImgs = splits(split).files.train;
testingImgs = splits(split).files.test;
trainingInd = splits(split).ind.train;
testingInd = splits(split).ind.test;
trainingLabels = cell2mat(labels(trainingInd));
testingLabels = cell2mat(labels(testingInd));

models = cell(1, nCrowdLevels);
trainingLevels = [trainingLabels.crowdLevel];
testingLevels = [testingLabels.crowdLevel];
for i=1:nCrowdLevels
    [X, Y] = sampling(params, trainingImgs(trainingLevels==i), features);
    model = training_mkl(X, Y);
    model.trainingImgs = trainingImgs(trainingLevels==i);
    model.testingImgs = testingImgs(testingLevels==i);
    models{i} = model;
end

save(fullfile(params.path.data, 'model_mkl.mat'), 'models', 'features');