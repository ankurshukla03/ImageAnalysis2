% close all
% clear

%% Load images
A = imread('01.png');
B = imread('02.png');
% C = imread('03.png');

%% Store some parameters
orig_size = size(A);
new_size = [200 200];
sf = orig_size(1:2)./new_size;

%% Resize images. This is to make everything run faster
a = imresize(A,new_size,'bilinear');
b = imresize(B,new_size,'bilinear');
% c = imresize(C,new_size,'bilinear');

%% Convert to grayvalue
a_gray = rgb2gray(a);
b_gray = rgb2gray(b);
% c_gray = rgb2gray(c);

%% Smooth images and calculate the Laplace-edgemap.

% Sigma for smoothing filter
sigma = 1; % >=1

a_edge = imfilter((double(imfilter(a_gray,fspecial('gaussian',(floor(sigma*6)+1)*[1 1],sigma),'symmetric'))),fspecial('laplacian'),'symmetric');
b_edge = imfilter((double(imfilter(b_gray,fspecial('gaussian',(floor(sigma*6)+1)*[1 1],sigma),'symmetric'))),fspecial('laplacian'),'symmetric');
% c_edge = imfilter((double(imfilter(c_gray,fspecial('gaussian',(floor(sigma*6)+1)*[1 1],sigma),'symmetric'))),fspecial('laplacian'),'symmetric');

%% Pad the images to make room for matching process
base_image = padarray(a_edge,size(a_edge),0);
floating_image = padarray(b_edge,size(b_edge),0);
% floating_image2 = padarray(c_edge,size(c_edge),0);

%% Defining the set of allowed transformations
angle_interval = -16:2:16;
row_interval = -80:5:80;
col_interval = -80:5:80;

%% Perform the matching process (ev. for both images)
score = exhaustive_match(base_image,floating_image,angle_interval,row_interval,col_interval);
% score2 = exhaustive_match(base_image,floating_image2,angle_interval,row_interval,col_interval);

%% Locate the best transformation for floating image 1
[~,I] = min(score(:));
[x,y,z] = ind2sub(size(score),I);

%% Perform the best transformation for floating image 1
rotated_image = imrotate(padarray(B,orig_size(1:2),0),angle_interval(x),'bilinear','crop');
translated_image = imtranslate(rotated_image,round(row_interval(y).*sf(1)),round(col_interval(z).*sf(2)));

%% Locate the best transformation for floating image 2
% [~,I] = min(score2(:));
% [x,y,z] = ind2sub(size(score2),I);

%% Perform the best transformation for floating image 2
% rotated_image = imrotate(padarray(C,orig_size(1:2),0),angle_interval(x),'bilinear','crop');
% translated_image2 = imtranslate(rotated_image,round(row_interval(y).*sf(1)),round(col_interval(z).*sf(2)));

%% Illustrate result
rgb = meanRGB(padarray(A,orig_size(1:2),0),translated_image);
% rgb = meanRGB(padarray(A,orig_size(1:2),0),translated_image,translated_image2);
[ind_r ind_c] = ind2sub(size(rgb(:,:,1)),find(rgb(:,:,1)>0)); 
rgb_crop = rgb(min(ind_r):max(ind_r),min(ind_c):max(ind_c),:);
figure;imshow(rgb_crop);

%% Illustrate the minimum intensity projection for score
figure('name','Min projection')
h = imagesc(squeeze(min(score,[],1)));
axis equal
xlabel('Rows')
ylabel('Columns')
set(gca, 'XTick', [1:2:length(row_interval)],...
    'YTick', [1:2:length(col_interval)],...
    'XTicklabel',row_interval(1:2:end),...
    'YTicklabel',col_interval(1:2:end));
title('Minimum intensity projection')
colormap gray
