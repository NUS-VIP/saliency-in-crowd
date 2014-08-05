function [allPosIndices, allNegIndices] = selectSamplesPerImg(labels, p, q, numImgs, dims, posPtsPerImg, negPtsPerImg)
%
% [allPosIndices, allNegIndices] = 
% selectSamplesPerImg(labels, p, q, numImgs, dims, posPtsPerImg, negPtsPerImg)
%
% Select data points on the following conditions:
% select positive examples randomly from top p salient
% select negative examples randomly from bottom q salient
% avoid the borders of image.

% ----------------------------------------------------------------------
% Matlab tools for "Learning to Predict Where Humans Look" ICCV 2009
% Tilke Judd, Kristen Ehinger, Fredo Durand, Antonio Torralba
% 
% Copyright (c) 2010 Tilke Judd
% Distributed under the MIT License
% See MITlicense.txt file in the distribution folder.
% 
% Contact: Tilke Judd at <tjudd@csail.mit.edu>
% ----------------------------------------------------------------------

allPosIndices = [];
allNegIndices = [];
%labels should be [M*N*numtrainingImages, 1]

numPixelsPerImage = length(labels) / numImgs;

for k=1:numImgs
    index = (k-1)*numPixelsPerImage;
    imageLabels=im2single(labels(index+1:index+numPixelsPerImage));
    
    % rearrange as a square and eliminate the borders
    border = 5; %num of pixels along the border that one should not choose from.
    imageLabels=reshape(imageLabels, [dims]);
    imageLabels(1:border, :) = -1;
    imageLabels(end-border+1:end, :) = -1;
    imageLabels(:, 1:border) = -1;
    imageLabels(:, end-border+1:end) = -1;

    imageLabels=reshape(imageLabels, [dims(1)*dims(2), 1]);
    [A, IX] = sort(imageLabels, 'descend');
    
    % Find the positive examples in the top p percent
    i = ceil((p/100)*length(imageLabels)*rand([posPtsPerImg, 1]));
    posIndices = IX(i);
    allPosIndices = [allPosIndices, posIndices'+index];
    
    % Find the negative examples from below top q percent
    % in practice, we find indices between [a, b]
    a = (q/100)*length(imageLabels); % top q percent
    b = length(imageLabels)-length(find(imageLabels==-1)); % index before border 
    j = ceil(a + (b-a).*rand(negPtsPerImg,1));
    negIndices = IX(j);
    allNegIndices = [allNegIndices, negIndices'+index];
    
    if 0
        [xp, yp]=ind2sub(dims, posIndices);
        [xn, yn]=ind2sub(dims, negIndices);
        imshow(reshape(imageLabels, [dims])); hold on;
        plot(yp, xp, 'o', 'MarkerFaceColor','g','MarkerSize',8 )
        plot(yn, xn, 'o', 'MarkerFaceColor','r','MarkerSize',8 )
        pause;
    end
end
