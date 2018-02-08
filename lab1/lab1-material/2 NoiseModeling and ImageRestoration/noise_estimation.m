% questions 11 - 16
cm = imread('cameraman noise.tif');

roi = roipoly(cm);

%
histogram = histroi(roi,[180 230],[20 130]);

%n=10 
stats = statmoments(roi,10);
