Saliency in Crowd
===================================
Matlab tools for "Saliency in crowd," ECCV, 2014   
Ming Jiang, Juan Xu, Qi Zhao
 
Copyright (c) 2014 NUS VIP - Visual Information Processing Lab

Distributed under the MIT License.
See LICENSE file in the distribution folder.

Contents
================

## Source Code

- demo.m:                             demonstrates the usage of this package. 
- src/common/config.m                 defines the configuration parameters.
- src/common/normalise.m              normalises a saliency map.
- src/dataset/computeFixationMaps.m   generates the human fixation maps.
- src/dataset/showEyeData.m           visualises the scanpaths of a given subject.
- src/metric/computeShuffleMap.m      computes the shuffle map for sAUC evaluation.
- src/metric/evaluateSaliencyMaps.m   evaluates the predicted saliency maps.
- src/model/collectFeatures.m         collects features for training and testing.
- src/model/computeIttiMaps.m         computes the pixel-level feature maps (Itti & Koch model).
- src/model/computeCrowdStats.m       computes the crowd statistics (density level, size, density, etc.)
- src/model/computeFaceMaps.m         computes the face feature maps.
- src/model/splitData.m	              splits the data into training and testing sets.
- src/model/sampling.m	              samples training data.
- src/model/training_mkl.m	          calls the simplemkl functions for model training.
- src/model/trainModel.m              trains the saliency model.
- src/model/computeSaliencyMaps.m     computes the predicted saliency maps.

## Data

- data/stimuli/*.jpg                  stimuli files
- data/eye/fixations.mat              eye-tracking data (fixation points and durations)
- data/labels.mat                     manually labelled faces (including ROIs and attributes)

## Dependencies

- lib/gbvs 							  Graph-Based Visual Saliency http://www.vision.caltech.edu/~harel/share/gbvs.php
- lib/simplemkl 				      LIBLINEAR http://www.csie.ntu.edu.tw/~cjlin/liblinear/

Getting Started
================

Open Matlab and run demo.m to compute the fixation maps, the feature maps, to learn and evaluate the saliency model.

Contacts
================

Send feedback, suggestions and questions to:   
Ming Jiang at <mjiang@nus.edu.sg>
