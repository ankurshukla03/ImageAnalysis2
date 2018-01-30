close all;
clear all;
img = imread('coins.png');

rows = 1;
cols = 2;

edges = edge(img,'canny',[0.20 0.7], 1);
subplot(rows,cols,1), imshow(edges);

rads=22:0.1:32;
hough = zeros(size(img,1), size(img,2), length(rads));

% vote
for x=1:size(edges,1)
    for y=1:size(edges,2)
        if edges(x,y) == 0
            continue;
        end
        for r_idx=1:length(rads)
            r = rads(r_idx);
            for angle=0:360
                a = ceil(x - r * cos(angle * pi / 180));
                b = ceil(y - r * sin(angle * pi / 180)); 
                if a > 0 && b > 0 && a <= size(edges,1) && b <= size(edges,2)
                    hough(a,b,r_idx) = hough(a,b,r_idx) + 1;
                end
            end
        end
    end
end

maxima = zeros(length(rads),1);
for r=1:length(rads)
    maxima(r) = max(max(hough(:,:,r)));
end

% find circles.
% we will see maxima at around 24 and 29.7 radii (indexes 41 and 97)
[mm, idxs] = findpeaks(maxima, 'SortStr', 'descend', 'MinPeakWidth', 3);

subplot(rows, cols, 2), imshow(img);
hold on
for i=1:numel(idxs)
   idx = idxs(i);
   % close holes, suppress spurrious maxima
   se = offsetstrel('ball',7,7);
   im = imclose(hough(:,:,idx), se);
   rad = 0.1 * idx + 20;
   for x=1:size(im,1)
       for y=1:size(im,2)
           if im(x,y) > 160 % magic number.
               viscircles([y,x], rad, 'Color', 'b');
               text(y,x, num2str(rad), ...
                    'Color', 'r', 'HorizontalAlignment', 'center');
           end
       end
   end
end
hold off