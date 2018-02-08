% adapted from chamferDemo
function scores = chamfer_match(base, img)

base = padarray(base,size(base),max(base(:)));
img = padarray(img,size(img),0);

% this should be parameterized in the function signature
step = 3;
translation_directions = [-0    -step; 
                          -step  0   ;
                           0     step; 
                           step  0   ];

last_score = inf; % Keep track of last positional score
stop = false; % Stop criterion
backwards = 0; % The direction which we came from
scores = []; % For plotting reasons
counter = 1;

while ~stop
    tmp_image = img; % Start with the current position
    scores = zeros(size(translation_directions,1),1); % To save the scores
    
    for i = 1 : size(translation_directions,1) 
        % Translate the image
        tmp_image = circshift(img,translation_directions(i,:));
        % Calculate the score of the translation
        scores(i)=sum(base(logical(tmp_image)));      
    end
    
    % Get the best score
    [best_score,dir]=min(scores);
    
    % Now see if we fulfil the stop criteria. Else continue
    
    if best_score > last_score || dir == backwards
        stop = true;
        scores(end+1) = best_score; %#ok
    else       
        img = imtranslate(img,translation_directions(dir,1),translation_directions(dir,2));
        backwards = mod(dir+1,4)+1;
        last_score = best_score;
        scores(end+1) = best_score; %#ok
    end
    
    figure(2)
    imshow(edgeRGBoverlay(base,img,'red'),[])
    title(['Floating image position for iteration ' num2str(counter)])

    counter = counter + 1;
end

end