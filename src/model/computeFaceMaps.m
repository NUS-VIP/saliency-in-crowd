function computeFaceMaps(params)
% computeFaceMaps(params)
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

features = {'size', 'density', 'frontal', 'profile'};
n = length(features);
outputPath = cell(n, 1);
for k = 1 : n
    outputPath{k} = fullfile(params.path.maps.feature, features{k});
    if ~exist(outputPath{k}, 'dir')
        mkdir(outputPath{k});
    end 
end

load(fullfile(params.path.data, 'stats.mat'));

for i = 1 : params.nStimuli
    maps = cell(n,1);
    fileName = params.stimuli{i};
    img = imread(fullfile(params.path.stimuli, fileName));
    [H W ~] = size(img);
    
    maps = zeros(H, W, n);
    faces = labels{i}.faces;
    for k = 1:labels{i}.nFaces
        c =faces{k}.center;
        maps(c(2), c(1), :) = [faces{k}.size
            faces{k}.density
            faces{k}.isFrontalFace
            faces{k}.isProfileFace];
    end
     
    for k = 1 : n
        map = imresize(maps(:, :, k), [params.out.height params.out.width]);
        map = imfilter(map, params.out.gaussian);
        map = normalise(map);
        imwrite(map, fullfile(outputPath{k}, fileName));
    end
end