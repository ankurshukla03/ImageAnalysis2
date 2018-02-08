% questions 17 - 20
clear all; 
close all;

img = rgb2gray(imread('search.png'));
template = rgb2gray(imread('template1.png'));
% template = rgb2gray(imread('template2.png'));

pad_x = size(img, 2); %cols
pad_y = size(img, 1); %rows

F = fft2(img);
G = fft2(template, pad_y, pad_x);

% cross power
nom = F .* conj(G);
denom = abs(F .* conj(G));
cp = real(ifft2(nom ./ denom));

[y, x] = find(cp == max(cp(:)));

imshow(img);
rectangle('Position',[x, y, size(template,1), size(template,2)]);
