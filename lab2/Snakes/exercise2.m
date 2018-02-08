% Exercise 2: Try to segment the pear!
%  - Preprocessing the image?
%  - Changing the external force?
%  - Changing the parameters?

% (C) Copyright 2011, Cris Luengo.
close all;

%% Parameters, original: 0.2, 0.4, 1, 0
alpha = 0.8; % membrane (length)
beta = 0.6;  % thin plate (curvature)
gamma = 1;   % step size
kappa = 0.6; % balloon force

%% Read in the image
orig_a = imread('pears.png');
orig_a = rgb2gray(orig_a);
orig_a = double(orig_a);

%% filter the image
% copy orig_a to a
a = imsharpen(orig_a);
h = fspecial('average', 7);  
a = imfilter(a, h, 'replicate'); % filter

%% Edge image and external force
e = gradmag(a,2); % orig: 2
f = vfc(e,50,2); % orig: 41, 2
 
%% Display images
figure
set(gcf,'position',[20,20,1000,700]);
colormap(gray(256))

subplot(2,2,1)
image(orig_a)
axis image
title('input image')

subplot(2,2,2)
image(e*(255/max(e(:))))
axis image
title('gradient magnitude')

subplot(2,2,4)
angle = atan2(f{2},f{1})*(1/(2*pi));
angle = mod(angle,1);
norm = sqrt(f{1}.^2+f{2}.^2);
norm = norm./max(norm(:));
col = cat(3,angle,norm,norm*0.5+0.5);
col = hsv2rgb(col);
image(col)
axis image
title('external force')

subplot(2,2,3)
image(orig_a)
axis image
title('evolving snake')
hold on

% Create initial snake
t = linspace(0,2*pi,100)'; t(end)=[];
s = [445+40*cos(t),205+50*sin(t)];
h = plot(s(:,1),s(:,2),'r');
pause(1)

% First 5 iteration steps
s = snakeminimize(s,f,alpha,beta,gamma,kappa,5);
set(h,'xdata',s(:,1),'ydata',s(:,2));
pause(1)

% Some more steps
s = snakeminimize(s,f,alpha,beta,gamma,kappa,5);
set(h,'xdata',s(:,1),'ydata',s(:,2));
pause(1)

s = snakeminimize(s,f,alpha,beta,gamma,kappa,10);
set(h,'xdata',s(:,1),'ydata',s(:,2));
pause(1)

s = snakeminimize(s,f,alpha,beta,gamma,kappa,10);
set(h,'xdata',s(:,1),'ydata',s(:,2));
pause(1)

s = snakeminimize(s,f,alpha,beta,gamma,kappa,20);
set(h,'xdata',s(:,1),'ydata',s(:,2));
pause(1)

s = snakeminimize(s,f,alpha,beta,gamma,kappa,20);
set(h,'xdata',s(:,1),'ydata',s(:,2));
