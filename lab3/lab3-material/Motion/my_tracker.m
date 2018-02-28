close all;

%% open video files
% read 250 of 581
start_f = 250;
end_f = 350;
assert(start_f < end_f);
mov = read_movie('source_sequence.avi', start_f, end_f);
mask = imread('bwmask.png');

output = VideoWriter('result.avi');
output.Quality = 100;
output.FrameRate = 30;
open(output);

height = size(mov,1);
width = size(mov,2);

colors = ["red", "green", "blue", "yellow"];

%% processing
% we'll be writing to this.
progressbar('frame');
for i=1:(end_f-start_f)
    % store current frame
    
    frame = mov(:,:,i);
    % smooth frame
    %h = fspecial('average', 5);
    %c_x = imfilter(frame, h);
    % binarize on some intensity
    c_x = c_x < 110; 
    frame = frame + mask;

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
        x = props(el).Centroid(1);
        y = props(el).Centroid(2);
        line(x,y,'marker','o','markersize',10,'LineWidth',2,...
            'Color', colors(el));
    end
    F = getframe(fig);
    writeVideo(output,F);
    progressbar(i/(end_f - start_f));
end

progressbar(1);
close(output);
