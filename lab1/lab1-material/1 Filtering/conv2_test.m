van = imread('van.tif');
van = uint8(van);
% if ~exist('mfprev', 'var')
%     mfprev=van;
% end

fsize = 5;
rows = 1;
cols = 2;

mf = fspecial('gaussian', [1 fsize], 1);
mf3 = fspecial('gaussian', [fsize fsize], 1);

% 'imfilter'
tic;
res1 = imfilter(van, mf3);
toc;

% 'conv2'
tic;
res2 = conv2(mf, mf', van);
toc;

subplot(rows, cols, 1), imagesc(res1);
subplot(rows, cols, 2), imagesc(res2);
