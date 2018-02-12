% question 1 and 2

clear all;
van = imread('van.tif');
van = uint8(van);
% if ~exist('mfprev', 'var')
%     mfprev=van;
% end

fsize = 15; %large filter sizes!
rows = 1;
cols = 2;

mfx = fspecial('gaussian', [1 fsize], 1);
mfy = mfx';
mf3 = fspecial('gaussian', [fsize fsize], 1);

% 'imfilter'
tic;
for i=1:500
res1 = conv2(mf3, van);
end
toc;

% 'conv2'
tic;
for i=1:500
res2 = conv2(mfx, mfy, van);
end
toc;

%subplot(rows, cols, 1), imagesc(res1);
%subplot(rows, cols, 2), imagesc(res2);
