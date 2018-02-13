close all;
clear all;

% change this if you want to see the images line up
animate = true;

%% Load images
A = imread('01.png');
B = imread('02.png');
C = imread('03.png');

%% Store some parameters
orig_size = size(A);
new_size = [200 200];
sf = orig_size(1:2)./new_size;

%% Resize images. This is to make everything run faster
a = imresize(rgb2gray(A),new_size,'bilinear');
b = imresize(rgb2gray(B),new_size,'bilinear');
c = imresize(rgb2gray(C),new_size,'bilinear');

%% Find B matches
[B_tran_scores, B_rot_scores, b_tran, b_rot] = chamfer_match(a, b, animate);

figure;
hold on
plot(B_tran_scores,'g');
plot(B_rot_scores,'r');
hold off
title('Position and Rotation scores')
ylabel('Scores')
xlabel('Iterations')
legend('Position', 'Rotation')

b_tran
b_rot

%% Find C matches
[C_tran_scores, C_rot_scores, c_tran, c_rot] = chamfer_match(a, c, animate);

figure;
hold on
plot(C_tran_scores,'g');
plot(C_rot_scores,'r');
hold off
title('Position(g)/Rotation(r) scores')
ylabel('Scores')
xlabel('Iterations')

c_tran
c_rot

%% Illustrate
A = padarray(A, orig_size(1:2), 0);
B = padarray(B, orig_size(1:2), 0);
C = padarray(C, orig_size(1:2), 0);

B = transform_img(B, b_rot, b_tran, orig_size, sf);
C = transform_img(C, c_rot, c_tran, orig_size, sf);

% adapted from ex_registration_exhaustive
combo = meanRGB(A,B,C);
[ind_r ind_c] = ind2sub(size(combo(:,:,1)),find(combo(:,:,1)>0)); 
cropped = combo(min(ind_r):max(ind_r),min(ind_c):max(ind_c),:);
figure;imshow(cropped);
