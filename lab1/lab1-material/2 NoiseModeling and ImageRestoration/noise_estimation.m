cm = imread('cameraman noise.tif');

roi = roipoly(cm,[180 230],[20 130]);

%
histogram = histroi(roi,[180 230],[20 130]);

%n=10 
stats = statmoments(roi,10);
