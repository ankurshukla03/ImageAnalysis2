close all;
clear all;

A = rgb2gray(imread('01.png'));
B = rgb2gray(imread('02.png'));
% C = rgb2gray(imread('03.png'));

%% Store some parameters
orig_size = size(A);
new_size = [200 200];
sf = orig_size(1:2)./new_size;

%% Resize images. This is to make everything run faster
a = imresize(A,new_size,'bilinear');
b = imresize(B,new_size,'bilinear');
% c = imresize(C,new_size,'bilinear');

%% Find matches
[B_tran_scores, B_rot_scores, b_tran, b_rot] = chamfer_match(a, b);
% [C_tran_scores, C_rot_scores, c_tran, c_rot] = chamfer_match(a, c);

figure;
hold on
plot(B_tran_scores,'g');
plot(B_rot_scores,'r');
hold off
title('Positional scores')
ylabel('Scores')
xlabel('Iterations')

b_tran
b_rot

% c_tran
% c_rot

%%
% find a better way to paramaterize this, PLEASE.
% A = imrotate(A,20);
% b = padarray(B,x(1:2)./2,0,'both');
% imshow(meanRGB(A, b));
