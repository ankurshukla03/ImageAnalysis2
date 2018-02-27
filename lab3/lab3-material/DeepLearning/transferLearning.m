%%++++ Set pwroking directory to path with source code
close all; clear all;

if(~isdeployed)
  cd(fileparts(which(mfilename)));
end
curdir = pwd;
aNet_wd = 227;
aNet_ht = 227;

%% Load data-set

datasetPath=[];
LOAD_MNIST = 1;
if(LOAD_MNIST ~= 0)
    digitDatasetPath = fullfile(matlabroot,'toolbox','nnet','nndemos',...
        'nndatasets','DigitDataset');
    digitData = imageDatastore(digitDatasetPath,...
        'IncludeSubfolders',true,'LabelSource','foldernames');
    figure;
    perm = randperm(10000,20);
    for i = 1:20
        subplot(4,5,i);
        imshow(digitData.Files{perm(i)});
    end
    datasetPath = digitDatasetPath;
end

LOAD_BIRDS = ~LOAD_MNIST;
if(LOAD_BIRDS ~= 0)
    birdDatasetPath = fullfile(curdir,'birds');
    birdData = imageDatastore(birdDatasetPath,...
        'IncludeSubfolders',true,'LabelSource','foldernames');
    figure;
    perm = randperm(600,20);
    for i = 1:20
        subplot(4,5,i);
        imshow(birdData.Files{perm(i)});
    end
    datasetPath = birdDatasetPath;
end

%% BLOCK-1 (begin) Load pre-trained Alex-net
load('comp_netTransfer.mat','net');
 %BLOCK-1 (end) 

%% BLOCK-2 (begin) Generate data-structure and labels for images

%augment_data(datasetPath,'D:\Masters\2ndSem\ImageAnalysis2Labs\lab3\lab3-material\DeepLearning\out',227,227,'basic',300)

augmentData = imageDatastore('D:\Masters\2ndSem\ImageAnalysis2Labs\lab3\lab3-material\DeepLearning\out',...
    'IncludeSubfolders',true,'LabelSource','foldernames');

[trainingImages,validationImages] = splitEachLabel(augmentData,0.7,'randomized');
numTrainImages = numel(trainingImages.Labels);
idx = randperm(numTrainImages,16);
figure;
for i = 1:16
    subplot(4,4,i)
    I = readimage(trainingImages,idx(i));
    imshow(I)
end
 %BLOCK-2 (end)

%% BLOCK-3 (begin) Network surgery
layersTransfer = net.Layers(1:end-3);

numClasses = numel(categories(trainingImages.Labels))
layers = [
    layersTransfer
    fullyConnectedLayer(numClasses,'WeightLearnRateFactor',20,'BiasLearnRateFactor',20)
    softmaxLayer
    classificationLayer];
miniBatchSize = 20;
numIterationsPerEpoch = floor(numel(trainingImages.Labels)/miniBatchSize);
% BLOCK-3 (end)

%% BLOCK-4 (begin) Network training
figure;
options = trainingOptions('sgdm',...
    'MiniBatchSize',miniBatchSize,...
    'MaxEpochs',4,...
    'InitialLearnRate',1e-4,...
    'Verbose',false,...
    'CheckpointPath','D:\Masters\2ndSem\ImageAnalysis2Labs\lab3\lab3-material\DeepLearning\log',...
    'OutputFcn',@plotTrainingAccuracy);
%% Prepare 4D data array
dataSize = numel(trainingImages.Labels);
xArray = uint8(zeros(aNet_ht,aNet_wd,3,dataSize));
for i = 1:dataSize
    xArray(:,:,:,i) = trainingImages.read;
end

%% Train the network
netTransfer = trainNetwork(xArray,trainingImages.Labels,...
                            layers,options);

%% Test the network
predictedLabels = classify(netTransfer,validationImages);

idx = [11 181 455 723];
figure
for i = 1:numel(idx)
    subplot(2,2,i)
    I = readimage(validationImages,idx(i));
    label = predictedLabels(idx(i));
    imshow(I)
    title(char(label))
end

%% Prediction accuracy
valLabels = validationImages.Labels;
accuracy = mean(predictedLabels == valLabels)
% BLOCK-4 (end)
