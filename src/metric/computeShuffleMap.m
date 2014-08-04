function computeShuffleMap(params)
% computeShuffleMap(params)
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

mapSize = [768 1024];
avg = zeros(mapSize);
for i = 1:params.nStimuli
    fileName = params.stimuli{i};
    load(fullfile(params.path.maps.fixation, fileName(1:end-4)));
    im = imresize(fixationPts, mapSize, 'nearest');
    avg = avg | im;
end

imwrite(avg, fullfile(params.path.data, 'shuffle_map.png'));
