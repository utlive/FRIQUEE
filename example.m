%% An example script to demonstrate FRIQUEE feature extraction and prediction of image quality.

% This script performs two tasks:

% 1 : Extracts FRIQUEE features

% 2 : Loads a learned model trained on all the images of LIVE Challenge Database and predicts the quality of the given example image. The quality is predicted on a scale of 0-100, where 0 represents the worst score and 1 represents the best score.

%Dependencies

%  The assumption here is that you have libsvm installed and
% svmpredict binary built
clear;
addpath('include/');
addpath('src/');
% Read an image
img = imread('data/sampleImg2.bmp');

% Extract FRIQUEE-ALL features of this image
testFriqueeFeats = extractFRIQUEEFeatures(img);

% Load a learned model
load('data/friqueeLearnedModel.mat');

% Scale the features of the test image accordingly.
% The minimum and the range are computed on features of all the images of
% LIVE Challenge Database
testFriqueeALL = testFeatNormalize(testFriqueeFeats.friqueeALL, friqueeLearnedModel.trainDataMinVals, friqueeLearnedModel.trainDataRange);

qualityScore = svmpredict (0, double(testFriqueeALL), friqueeLearnedModel.trainModel, '-b 1 -q');