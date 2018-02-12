% EXHAUSTIVE MATCH
% 
%  score = exhaustive_match(base_image,floating_image,angle_interval,row_interval,col_interval)
% 
%      base_image: 2D image (e.g. edge image) used as reference
%  floating_image: 2D image (e.g. edge image) to be registrated to 
%                  base_image
%  angle_interval: Vector containing allowed rotations (in degrees)
%    row_interval: Vector containing allowed row translations
%    col_interval: Vector containing allowed column translations
%           score: 3D score space
% 
% Description: exhaustive_match evauluates all the specified
% transformations, transforming the floating image and comparing it to the
% base image according to the given similarity measure. The result is a 
% 3D score space. 
% 
% Written by: Gustaf Kylberg och Patrik Malm, Nov. 2010

function score = exhaustive_match(base_image,floating_image,...
    angle_interval,row_interval,col_interval)

% Initiate score parameter space
score = zeros(length(angle_interval),length(row_interval),length(col_interval));

progressbar('deg','row','col');

% Loop through the transformation space and store the score for each
% position
for deg = 1 : length(angle_interval)
    
    % Rotate the image 
    rotated_image = imrotate(floating_image,angle_interval(deg),'nearest','crop');
    
    for row = 1 : length(row_interval)        
        for col = 1 : length(col_interval)
            
            % Translate the image
            tmp_image = imtranslate(rotated_image,row_interval(row),col_interval(col));
            
            % Compute the score according to given measure
            score(deg,row,col) = similarity(base_image,tmp_image,'mse');
            
            progressbar([],[],col/length(col_interval));
        end
        progressbar([],row/length(row_interval),[]);
    end
    progressbar(deg/length(angle_interval),[],[]);
end