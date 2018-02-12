% questions 9 and 10.

close all;
clear all;
cm = imread('cameraman.png');

rows = 2;
cols = 4;
M = 0;
idx = 1;

g_psnr_plot = zeros(100);
g_ssim_plot = zeros(100);
sp_psnr_plot = zeros(100);
sp_ssim_plot = zeros(100);

for lvl=[0.01:0.01:1.0]
    res1 = imnoise(cm, 'gaussian', M, lvl);
    res2 = imnoise(cm, 'salt & pepper', lvl);
%     subplot(rows, cols, idx), imshow(res1); 
%     fmtr = 'psnr: %.02f\nssim: %.02f'; % formatted string
%     t = sprintf(fmtr, psnr(res1, cm), ssim(res1, cm));
%     title(t);
%     subplot(rows, cols, idx+cols), imshow(res2);
%     t = sprintf(fmtr, psnr(res2, cm), ssim(res2, cm));
%     title(t);
    g_psnr_plot(idx) = psnr(res1,cm);
    g_ssim_plot(idx) = ssim(res1,cm);
    sp_psnr_plot(idx) = psnr(res2,cm);
    sp_ssim_plot(idx) = ssim(res2,cm);
    idx = idx + 1;
end

x = 1:100;
figure(1);
plot(x, g_psnr_plot, x, sp_psnr_plot);
title('PSNR');
legend('gaussian', 'salt & pepper');

figure(2);
plot(x, g_ssim_plot, x, sp_ssim_plot);
title('SSIM');
legend('gaussian', 'salt & pepper');
