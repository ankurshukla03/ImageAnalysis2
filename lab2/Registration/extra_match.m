%attempt 04
close all;

animate = true;

%% Load images
A = imread('03.png');
B = imread('04.png');

%% Store some parameters
orig_size = size(A);
new_size = [200 200];
sf = orig_size(1:2)./new_size;

%% preprocess B

b = rgb2gray(B);

h = fspecial('unsharp');
b = imfilter(b,h);

h = fspecial('gaussian', [10 10], 30);
b = imfilter(b,h);
% 
% h = fspecial('unsharp');
% b = imfilter(b,h);

mt = multithresh(b, 3); % trees, fields/roads, buildings
b = imquantize(b, mt);
b = imresize(b,new_size,'bilinear');
b = b * 50; % make it visible when animating

% for debug, chamfer_match does this, test with it.
% img = edge(b, 'canny', [0.1, 0.2], 1);
% figure(1)
% imagesc(b);
% 
% figure(2)
% imagesc(img);

%% 
a = imresize(rgb2gray(A),new_size,'bilinear');
% b = imresize(b,new_size,'bilinear');

[B_tran_scores, B_rot_scores, b_tran, b_rot] = chamfer_match(a, b, true);

%% Illustrate
A = padarray(A, orig_size(1:2), 0);
B = padarray(B, orig_size(1:2), 0);

B = transform_img(B, b_rot, b_tran, orig_size, sf);

% adapted from ex_registration_exhaustive
combo = meanRGB(A,B);
[ind_r ind_c] = ind2sub(size(combo(:,:,1)),find(combo(:,:,1)>0)); 
cropped = combo(min(ind_r):max(ind_r),min(ind_c):max(ind_c),:);
figure;imshow(cropped);

