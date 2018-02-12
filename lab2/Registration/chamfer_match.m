function [tran_scores, rot_scores, tran, rot] = chamfer_match(base, img)
% copy for later
plain_img = img;

%% canny both images, distance transform base
t1 = 0.1;
t2 = 0.2;
sigma = 0.8;

base_edges = edge(base,'canny',[t1 t2],sigma);
dist_base = bwdist(base_edges, 'euclidean');

% img = edge(img, 'canny', [t1, t2], sigma);

%% pad images

base      = padarray(base,size(base),0); % for overlay
dist_base = padarray(dist_base,size(dist_base),5);

img = padarray(img,size(img),0);
plain_img = padarray(plain_img,size(plain_img),0); % for overlay
orig_img = img; % so repetitive rotation doesn't distort

% make sure we're not double padding
assert(isequal(size(dist_base), size(img)));

%% parameter initialization
step = 4;
translation_directions = [-0    -step; % up
                          -step  0   ; % left
                           0     step; % down 
                           step  0   ];% right

rotation_directions = -32:2:32; 

%total transform and rotations
tran = [0 0];
rot = 0;

% The direction which we came from
back_tran = 0; 
back_rot = 0;

% last score
last_tran = inf;
last_rot = inf;

% For plotting reasons
rot_scores = []; 
tran_scores = [];
counter = 1;

% Stop criterion
stop_tran = false; 
stop_rot = false;

%% loop
while ~stop_tran && ~stop_rot
    %% get scores for translation and rotations
    % to save scores
    tran_scores = zeros(size(translation_directions,1),1);
    rot_scores = zeros(length(rotation_directions),1); 
    for i = 1 : size(translation_directions,1) 
        % Translate the image
        tmp_image = circshift(img,translation_directions(i,:));
        % Calculate the score of the translation
        tran_scores(i) = sum(dist_base(logical(tmp_image)));      
    end
    
    for i=1:numel(rotation_directions)
        tmp_image = imrotate(img, rotation_directions(i), 'nearest', 'crop');
        rot_scores(i) = sum(dist_base(logical(tmp_image)));
    end
    
    %% Get the best score, make the best transforms
    [best_tran,tran_ind] = min(tran_scores);
    
    % translation
    if ~stop_tran && best_tran > last_tran+100 || tran_ind == back_tran
        stop_tran = true;
        tran_scores(end+1) = best_tran; %#ok
    else
        tran = tran + [translation_directions(tran_ind, 1) ...
                       translation_directions(tran_ind, 2)];           
        back_tran = mod(tran_ind+1,4)+1;
        tran_scores(end+1) = best_tran; %#ok
    end
    
    % rotation
    [best_rot,rot_ind] = min(rot_scores);
    c_rot = rotation_directions(rot_ind);
    if ~stop_rot && best_rot > last_rot+10 || c_rot == back_rot
        stop_rot = true;
        rot_scores(end+1) = best_rot; %#ok
    else 
        back_rot = -c_rot;
        rot = rot + c_rot;
        rot_scores(end+1) = best_rot; %#ok
    end
     
    % get the best quality rotated image for the next iteration.
    img = imrotate(orig_img, rot, 'nearest', 'crop');
    img = circshift(img, tran);
    
    %% visualize diff
    vis = imrotate(plain_img, rot, 'nearest', 'crop');
    vis = circshift(vis, tran);
    
    figure(2)
    imshow(meanRGB(base,vis))
    title(['Floating image position for iteration ' num2str(counter)])
    
    counter = counter + 1;
end

end