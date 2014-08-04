function [ params ] = config()
% [ params ] = config()
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

params.root = '.';

params.path.data = [params.root, '/data'];
params.path.stimuli = [params.path.data, '/stimuli'];
params.path.maps.fixation = [params.path.data, '/fixation_maps'];

params.path.labels = [params.path.data, '/labels'];
params.path.eye = [params.path.data, '/eye'];
params.path.raw = [params.path.data, '/eye/raw'];

params.path.maps.feature = [params.path.data, '/feature_maps'];
params.path.maps.saliency = [params.path.data, '/saliency_maps'];

params.file.fixations = [params.path.eye, '/fixations.mat'];

params.eye.radius = 26;

params.ext = '.jpg';

params.out.sigma = 6.5;
params.out.width = 256;
params.out.height = 192;

params.ml.nCrowdLevel = 4;
params.ml.nSplit = 10;
params = postConfig(params);
end

function [params] = postConfig( params )
winSize = ceil(params.eye.radius * 7);
params.eye.gaussian = fspecial('gaussian', [winSize winSize], params.eye.radius);

winSize = ceil(params.out.sigma * 7);
params.out.gaussian = fspecial('gaussian', [winSize winSize], params.out.sigma);

files = dir([params.path.stimuli, '/*', params.ext]);
params.stimuli = {files.name};
params.nStimuli = length(params.stimuli);
end
