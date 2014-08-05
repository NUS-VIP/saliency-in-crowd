function computeSaliencyMaps(params)
% computeSaliencyMaps(params)
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

load(fullfile(params.path.data, 'model_mkl.mat'));

outputPath = params.path.maps.saliency;
if ~exist(outputPath, 'dir')
    mkdir(outputPath);
end

for i = 1:length(models)
    model = models{i};
    meanVec = model.whiteningParams(1, :);
    stdVec = model.whiteningParams(2, :);
    
    for j = 1 :length(model.testingImgs)
        fileName = model.testingImgs{j};
        
        X = collectFeatures(params, model.testingImgs(j), features);
        X = bsxfun(@minus, X, meanVec);
        X = X ./ repmat(stdVec, [size(X,1) 1]);
        
        Kt=mklkernel(X,model.InfoKernel,model.Weight,model.options,model.xapp,model.beta);
        predictions =Kt*model.w+model.b;
        
        map = reshape(predictions, [params.out.height params.out.width]);
        
        map = imfilter(map, params.out.gaussian);
        map = normalise(map);
        imwrite(map, fullfile(outputPath, fileName));
    end
end

end
