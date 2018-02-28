close all;

%% open video files
% read 250 of 581
start_f = 100;
end_f = 400;
assert(start_f < end_f);
mov = read_movie('source_sequence.avi', start_f, end_f);
mask = imread('bwmask.png');

output = VideoWriter('result.avi');
output.Quality = 100;
output.FrameRate = 30;
open(output);

height = size(mov,1);
width = size(mov,2);

colors = ["red", "green", "blue", "yellow", "magenta", "cyan"];

%% processing
progressbar('frame');
prev_points = inf(5,2);
next_points = prev_points;
prev_colors = strings(5,1);
for i=1:(end_f-start_f)
    % get the current frame, mask out the center
    frame = mov(:,:,i);
    frame = frame + mask;
    % smooth frame
    h = fspecial('average', 3);
    c_x = imfilter(frame, h, 'replicate');
    % binarize on some intensity
    c_x = c_x < 100; 

    Lb_Img = bwlabel(c_x);
    Comps = bwconncomp(Lb_Img);
    props = regionprops(Comps,'Area','centroid');

    % for each prop draw a circle
    fig = figure(10);
    imh = imshow(frame);
    hold on;
    for el=1:numel(props)
        if props(el).Area > 90
            continue;
        end
        % init prev points
        x = props(el).Centroid(1);
        y = props(el).Centroid(2);
        cur = [x,y];
        if all(prev_points(el,:) == Inf)
            next_points(el,:) = cur;
            c_color = colors(el);
            prev_colors(el) = c_color;
        else 
            dist = sqrt(...
                (prev_points(:,1)-cur(:,1)).^2 + ...
                (prev_points(:,2)-cur(:,2)).^2);
            [~, ind] = min(dist);
            c_color = prev_colors(ind);
            next_points(ind,:) = cur;
        end
        line(x,y,'marker','o','markersize',10,'LineWidth',2,...
            'Color', c_color);
    end
    prev_points = next_points;
    next_points = inf(5,2);
    F = getframe(fig);
    writeVideo(output,F);
    progressbar(i/(end_f - start_f));
end

progressbar(1);
close(output);
