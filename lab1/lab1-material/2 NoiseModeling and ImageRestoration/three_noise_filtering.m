v_img = readVTK('hydrogen.vtk');

% guassian
g_img = imnoise(v_img, 'gaussian', 0, 0.00005);

% median
g_img_med  = ordfilt3D(g_img, 14);

h = ones(3,3,3) / 27;
g_img_mean = imfilter(g_img, h);

volrender(g_img);
title('gaussian noise');

volrender(g_img_med);
title('gaussian noise, median filter');

volrender(g_img_mean);
title('gaussian noise, mean filter');

pause;
close all;
% -----------------------
% salt & pepper
sp_img = imnoise(v_img, 'salt & pepper', 0.01);

% median
sp_img_med  = ordfilt3D(sp_img, 14);

% mean
h = ones(3,3,3) / 9;
sp_img_mean = imfilter(sp_img, h);

volrender(sp_img);
title('s&p noise');

volrender(sp_img_med);
title('s&p noise, median filter');

volrender(sp_img_mean);
title('s&p noise, mean filter');
pause;
close all;