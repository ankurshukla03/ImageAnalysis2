%%++++ Set pwroking directory to path with source code
close all; clear all;

if(~isdeployed)
  cd(fileparts(which(mfilename)));
end
curdir = pwd;

%% Load pre-trained Alex-net 
load('comp_netTransfer.mat');

%% Visualize features from initial layers
layer = 2;
channels = 1:56;
dispFeatures(net,layer,channels);
dispFeatures(netTransfer,layer,channels)

%% Visualize features from FC layers
layers = [17 20];
channels = 1:6;
dispFeatures(net,layers,channels,50);
dispFeatures(netTransfer,layers,channels,50);
