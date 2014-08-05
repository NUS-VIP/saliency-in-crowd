function allfeatures = collectFeatures(params, images, features)
% allfeatures = collectFeatures(params, images, features)
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

H = params.out.height;
W = params.out.width;

allfeatures = zeros(length(images) * H * W, length(features));
for i = 1 : length(images)
    index = (i - 1) * H * W;
    for j = 1 : length(features)
        map = im2double(imread(fullfile(params.path.maps.feature, features{j}, images{i})));
        map = imresize(map, [H W]);
        allfeatures(index + 1:index + H * W, j) = map(:);
    end
end
end