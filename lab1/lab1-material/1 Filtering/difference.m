van = imread('van.tif');
% if ~exist('mfprev', 'var')
%     mfprev=van;
% end

fsize = 3;
rows = 1;
cols = 4;

h1 = fspecial('gaussian', [fsize fsize], 1);
h2 = fspecial('gaussian', [fsize fsize], 0.5);

res1 = imfilter(van,h1);
res2 = imfilter(van,h2);
res3 = res1 - res2;
res4 = imfilter(van, (h1-h2));

subplot(rows, cols, 1), imagesc(res1);
subplot(rows, cols, 2), imagesc(res2);
subplot(rows, cols, 3), imagesc(res3);
subplot(rows, cols, 4), imagesc(res4);

