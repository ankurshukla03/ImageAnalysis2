function transform_img = transform_img(img, rot, tran, orig, ratio)

% scale translations back to original sizes
tran = floor(tran .* ratio(1:2));
img = imrotate(img, rot, 'nearest', 'crop');
transform_img = circshift(img, tran(:));

end