cm = imread('cameraman.png');

rows = 2;
cols = 4;
M = 0;
idx = 1;
for lvl=[0.02,0.03,0.04,0.05]
    res1 = imnoise(cm, 'gaussian', M, lvl);
    res2 = imnoise(cm, 'salt & pepper', lvl);
    subplot(rows, cols, idx), imshow(res1); 
    fmtr = 'psnr: %.02f ssim: %.02f'; % formatted string
    t = sprintf(fmtr, psnr(res1, cm), ssim(res1, cm));
    title(t);
    subplot(rows, cols, idx+cols), imshow(res2);
    t = sprintf(fmtr, psnr(res2, cm), ssim(res2, cm));
    title(t);
    idx = idx + 1;
end
