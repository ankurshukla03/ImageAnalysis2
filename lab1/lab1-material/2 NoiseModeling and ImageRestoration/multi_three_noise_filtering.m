v_img = readVTK('hydrogen.vtk');

array = cell(27,1);
for i = 1 : 27
  array{i} = imnoise(v_img, 'guassian', 0, 0.00005);
end

% Take the mean value of each voxel among the 27 images. 
% Compare this result with the mean filtered image in the previous question.