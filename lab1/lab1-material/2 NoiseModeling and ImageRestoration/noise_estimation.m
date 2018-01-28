cm = imread('cameraman noise.tif');

roi = roipoly(cm);

%selecting region of interest by mouse 

%
histogram = histroi(roi,0,256);

%n=10 
stats = statmoments(roi,10);


