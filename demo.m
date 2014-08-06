% This Matlab script demonstrates the usage of this package.
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


fprintf('Setting up the environment.\n');
tic;

addpath(genpath('src'));

% initialize GBVS

cd lib/gbvs
gbvs_install
cd ../..

% initialize simplemkl
addpath('lib/simplemkl');
cd lib/simplemkl
mex vectorize.c
mex vectorize_single.c
mex devectorize.c
mex devectorize_single.c
cd ../..

% compile auc helper
cd src/metric
mex -D__MEX auc_steps_helper.cpp
cd ../..

toc;

% load parameters
p = config;

fprintf('Computing fixation maps.\n');
tic;
computeFixationMaps(p);
toc;

fprintf('Computing crowd statistics.\n');
tic;
computeCrowdStats(p);
toc;

fprintf('Computing Itti & Koch saliency maps.\n');
tic;
computeIttiMaps(p);
toc;
fprintf('Computing face maps.\n');
tic;
computeFaceMaps(p);
toc;

% compute shuffle map for sAUC evaluation
computeShuffleMap(p);

% train and evaluate the saliency model with an n-fold cross validation
fprintf('Training and testing linear SVM model.\n');
tic;
splitData(p);
auc = cell(1, p.ml.nSplit);
nss = cell(1, p.ml.nSplit);
cc = cell(1, p.ml.nSplit);
curves = cell(1, p.ml.nSplit);
for split = 1:p.ml.nSplit
    trainModel(p, split);
    computeSaliencyMaps(p);
    [auc{split}, nss{split}, cc{split}, curves{split}] = evaluateSaliencyMaps(p, split);
end
toc;