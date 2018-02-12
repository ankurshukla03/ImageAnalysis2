cmn = imread('cameraman noise.tif');
cm = imread('cameraman.png');

x = [7 20 55 75];
y = [135 240 90 210];
roi = roipoly(cm,x,y);

noNoise = cm .* uint8(roi); 
Noisy = cmn .* uint8(roi); 

partlypsnr = psnr(Noisy,noNoise);
fullpsnr = psnr(cmn, cm); 

%
histogram = histroi(cmn,x,y);

%n=10 
stats = statmoments(histogram,10);
