function model = training_mkl(X, Y)
%  model = training_mkl(X, Y)
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

%%%%%%%%%%%%
% Training %
%%%%%%%%%%%%

% normalise the training data
meanVec=mean(X, 1);
X=X-repmat(meanVec, [size(X, 1), 1]);

stdVec=std(X);
stdVec(stdVec==0) = 1;
X=X./repmat(stdVec, [size(X, 1), 1]);

whiteningParams = [meanVec; stdVec];

fprintf('Training the model...');
C = 1;
verbose=0;

% Choice of algorithm in mklsvm can be either
% 'svmclass' or 'svmreg'
options.algo='svmclass'; 

%------------------------------------------------------
% choosing the stopping criterion
%------------------------------------------------------
options.stopvariation=0;  % use variation of weights for stopping criterion 
options.stopKKT=0;        % set to 1 if you use KKTcondition for stopping criterion    
options.stopdualitygap=1; % set to 1 for using duality gap for stopping criterion

%------------------------------------------------------
% choosing the stopping criterion value
%------------------------------------------------------
options.seuildiffsigma=1e-2;        % stopping criterion for weight variation 
options.seuildiffconstraint=0.1;    % stopping criterion for KKT
options.seuildualitygap=0.01;       % stopping criterion for duality gap

%------------------------------------------------------
% Setting some numerical parameters 
%------------------------------------------------------
options.goldensearch_deltmax=1e-1; % initial precision of golden section search
options.numericalprecision=1e-8;   % numerical precision weights below this value
                                   % are set to zero 
options.lambdareg = 1e-8;          % ridge added to kernel matrix 

%------------------------------------------------------
% some algorithms paramaters
%------------------------------------------------------
options.firstbasevariable='first'; % tie breaking method for choosing the base 
                                   % variable in the reduced gradient method 
options.nbitermax=500;             % maximal number of iteration  
options.seuil=0;                   % forcing to zero weights lower than this 
options.seuilitermax=10;           % value, for iterations lower than this one 

options.miniter=0;                 % minimal number of iterations 
options.verbosesvm=0;              % verbosity of inner svm algorithm 
options.efficientkernel=1;         % use efficient storage of kernels 


%------------------------------------------------------------------------
%                   Building the kernels parameters
%------------------------------------------------------------------------
kernelt={ 'gaussian' 'poly' };
kerneloptionvect={[0.05 0.1 0.2 0.4] [1 2 3]};
variablevec={'single' 'single'};


Y(Y==0) = -1;
[nbdata,dim]=size(X);

[kernel,kerneloptionvec,variableveccell]=CreateKernelListWithVariable(variablevec,dim,kernelt,kerneloptionvect);
[Weight,InfoKernel]=UnitTraceNormalization(X,kernel,kerneloptionvec,variableveccell);
K=mklkernel(X,InfoKernel,Weight,options);
[beta,w,b,posw,story,obj] = mklsvm(K,Y,C,options,verbose);

model.InfoKernel = InfoKernel;
model.Weight = Weight;
model.options = options;
model.posw = posw;
model.beta = beta;
model.w = w;
model.b = b;
model.xapp = X(posw,:);
model.whiteningParams = whiteningParams;

end
