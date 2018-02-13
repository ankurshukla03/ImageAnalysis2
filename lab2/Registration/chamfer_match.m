function [tran_scores, rot_scores, tran, rot] = chamfer_match(base, img, anim)
% copy for later
plain_img = img;

%% canny both images, distance transform base
t1 = 0.1;
t2 = 0.2;
sigma = 0.8;

base_edges = edge(base,'canny',[t1 t2],sigma);
dist_base = bwdist(base_edges, 'euclidean');

img = edge(img, 'canny', [t1, t2], sigma);

%% pad images

base      = padarray(base,size(base),0); % for overlay
dist_base = padarray(dist_base,size(dist_base),1);

img = padarray(img,size(img),0);

plain_img = padarray(plain_img,size(plain_img),0); % for overlay
orig_img = img; % so repetitive rotation doesn't distort

% make sure we're not double padding
assert(isequal(size(dist_base), size(img)));

%% parameter initialization
step = 2;
translation_directions = directions(step);
rotation_directions = -32:2:32; 

%total transform and rotations
tran = [0 0];
rot = 0;

% The direction which we came from
back_tran = 0; 
back_rot = 0;

% last scores
last_tran = inf;
last_rot = inf;

% count repetitions, unused
% rep_thresh = 20;
% tran_reps = 0; 
% rot_reps = 0;

% For plotting reasons
rot_scores = []; 
tran_scores = [];
counter = 1;

% Stop criterion
stop_tran = false; 
stop_rot = false;

%% loop
while ~stop_tran
    %% translation
    translation_directions = directions(step);
    dirs = size(translation_directions, 1);
    
    test_tran_scores = zeros(size(translation_directions,1),1);
    test_rot_scores = zeros(length(rotation_directions),1); 
    for i = 1 : size(translation_directions,1) 
        % Translate the image
        tmp_image = circshift(img,translation_directions(i,:));
        % Calculate the score of the translation
        test_tran_scores(i) = sum(dist_base(logical(tmp_image)));      
    end
    
    [best_tran,tran_ind] = min(test_tran_scores);
    t_diff = best_tran - last_tran;
    if ~stop_tran && last_tran ~= inf && t_diff > 1400 
        stop_tran = true;
        tran_scores(end+1) = best_tran; %#ok
        % final translation value
    else
        % get a new step
        if last_tran ~= inf
            if abs(t_diff) < 150
                step = 3;
            else 
                step = ceil(10 * (best_tran / last_tran));
            end
        end
        tran = tran + [translation_directions(tran_ind, 1) ...
                       translation_directions(tran_ind, 2)]; 
        last_tran = best_tran;
        back_tran = mod(tran_ind+1, dirs)+1;
        tran_scores(end+1) = best_tran; %#ok
    end
    
    %% rotation
    for i=1:numel(rotation_directions)
        tmp_image = imrotate(img, rotation_directions(i), 'nearest', 'crop');
        test_rot_scores(i) = sum(dist_base(logical(tmp_image)));
    end
    
    [best_rot,rot_ind] = min(test_rot_scores);
    
    r_diff = abs(best_rot - last_rot);
    c_rot = rotation_directions(rot_ind);
    if ~stop_rot && r_diff < 100 || (rot == back_rot && rot ~= 0)
        stop_rot = true;
        rot_scores(end+1) = best_rot; %#ok
        % final rotation value.
        rot = rot + c_rot; 
    % unless there is some better value after translation!
    elseif best_rot < last_rot
        rot = rot + c_rot;
        back_rot = -c_rot;
        last_rot = best_rot;
        rot_scores(end+1) = best_rot; %#ok
    end
        
    %% get the best quality rotated image for the next iteration.
    img = imrotate(orig_img, rot, 'nearest', 'crop');
    img = circshift(img, tran);
    
    %% visualize diff
    if anim
       
        vis = imrotate(plain_img, rot, 'nearest', 'crop');
        vis = circshift(vis, tran);

        figure(2)
        imshow(meanRGB(base,vis))
        title(['Floating image position for iteration ' num2str(counter)])
    end 
    counter = counter + 1;
end

end

function directions = directions(step)
%     directions = [-0    -step; % up
%                   -step  0   ; % left
%                    0     step; % down 
%                    step  0  ];% right
% 8 direction
    directions = [-0    -step; % north
                   step -step; % ne
                   step  0   ; % east
                   step  step; % se
                   0     step; % south 
                   -step step; % sw
                   -step  0  ; % west
                   -step -step]; % nw
end