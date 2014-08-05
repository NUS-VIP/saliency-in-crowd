function computeCrowdStats( params )
% computeCrowdStats( params )
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



load(fullfile(params.path.data, 'labels.mat'));

tmp = cell2mat(labels);
nFaces = [tmp.nFaces];

nCrowdLevels = params.ml.nCrowdLevel;
blocksize = ceil(params.nStimuli / nCrowdLevels);
edgeIdx = 1:blocksize:params.nStimuli;
tmp = sort(nFaces);
edges = tmp(edgeIdx);

levelEdges = [edges inf];
[~, crowdLevel] = histc(nFaces, levelEdges);

sigma = params.eye.radius*2;
for i=1:params.nStimuli
    if isempty(labels{i}) || labels{i}.nFaces==0
        continue;
    end
    
    density = zeros(labels{i}.nFaces);
    faces = labels{i}.faces;
    for x = 1:labels{i}.nFaces-1
        for y = x+1:labels{i}.nFaces
            r1 = faces{x}.center-faces{y}.center;
            d = exp(-norm(r1)^2/2/sigma/sigma) / sqrt(pi*2) / sigma;
            density(x,y) = d;
            density(y,x) = d;
        end
    end
    density = sum(density);
    for j=1:labels{i}.nFaces
        faces{j}.size = sqrt(faces{j}.width * faces{j}.height);
        faces{j}.density = density(j);
    end
    labels{i}.crowdLevel = crowdLevel(i);
    labels{i}.faces = faces;
end

save(fullfile(params.path.data, 'stats.mat'), 'labels', 'nCrowdLevels', 'levelEdges');
end
