cm = imread('cameraman noise.tif');

roi = roipoly(cm,[180 230],[20 130]);

%selecting region of interest by mouse 

%
histogram = histroi(roi,0,256);

%n=10 
stats = statmoments(roi,10);


