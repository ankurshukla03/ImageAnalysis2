close all;

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

%% Find matches
B_scores = chamfer_match(A, B);
% C_scores = chamfer_match(A, C);

figure;
plot(accumulated_scores,'r');
title('Positional scores')
ylabel('Scores')
xlabel('Iterations')