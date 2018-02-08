% questions 6 and 7

close all;
clear all;
v_img = readVTK('hydrogen.vtk');

array = cell(27,1);
for i = 1 : 27
  array{i} = imnoise(v_img, 'gaussian', 0, 0.00005);
end

% Take the mean value of each voxel among the 27 images.
% Compare this result with the mean filtered image in the previous question.

final = zeros(size(v_img));
for i = 1:size(v_img, 1)
    for j = 1:size(v_img, 2)
        for k = 1:size(v_img, 3)
            vals = zeros(27,1);
            for l = 1:27
                vals(l) = array{l}(i,j,k);
            end
            final(i,j,k) = mean(vals);
        end
    end
end

volrender(final);