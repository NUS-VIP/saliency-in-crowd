function [ normalised ] = normalise( map )
% [ normalised ] = normalise( map )
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

map = map - min(min(map));
s = max(max(map));
if s > 0
    normalised = map / s;
else
    normalised = map;
end

end
