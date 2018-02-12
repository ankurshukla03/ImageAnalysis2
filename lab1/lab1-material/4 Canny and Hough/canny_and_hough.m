% questions 21-25

close all;
clear all;
img = imread('coins.png');
%% canny edges
% edges = edge(img,'canny',[0.20 0.7], 1);
edges = edge(img,'canny',[0.18 0.65], 1);

figure(1);
imshow(edges);

%% vote
rads=22:0.1:32;
hough = zeros(size(img,1), size(img,2), length(rads));

for x=1:size(edges,1)
    for y=1:size(edges,2)
        if edges(x,y) == 0
            continue;
        end
        for r_idx=1:length(rads)
            r = rads(r_idx);
            for angle=0:360
                a = round(x - r * cos(angle * pi / 180));
                b = round(y - r * sin(angle * pi / 180)); 
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

%% find circles.
% we will see maxima at around 24 and 29.7 radii (indexes 41 and 97)
[mm, idxs] = findpeaks(maxima, 'SortStr', 'descend', 'MinPeakWidth', 5);

figure(2);
imshow(img);
hold on
for i=1:numel(idxs) % limit the number of maxima, we only want to find two coin sizes
   idx = idxs(i);
   % expand the peaks with a large dilate
   base = hough(:,:,idx);
   dse = strel('disk', 10);
   im = imdilate(base, dse);
   rad = 0.1 * idx + 20;
   for x=1:size(im,1)
       for y=1:size(im,2)
           % if the im(x,y) was unchanged from the dilate, 
           % it's the center of a circle!
           if im(x,y) == base(x,y) && im(x,y) > 150
               % rad+1 to compansate for the width of the circle stroke
               viscircles([y,x], rad+1, 'Color', 'b');
               text(y,x, num2str(rad), ...
                    'Color', 'r', 'HorizontalAlignment', 'center');
           end
       end
   end
end
hold off