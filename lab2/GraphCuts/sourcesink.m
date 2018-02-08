function sourcesink()
    % An example of how to segment a color image according to pixel colors.
    % Fisrt stage identifies k distinct clusters in the color space of the
    % image. Then the image is segmented according to these regions; each pixel
    % is assigned to its cluster and the GraphCut poses smoothness constraint
    % on this labeling.

    close all

    addpath('./GCmex/');
    %check for mex files, compile if not found
    if(~(exist('GraphCut3dConstr.mexa64') && ...
        exist('GraphCutConstr.mexa64') && ...
        exist('GraphCutConstr.mexa64') && ...
        exist('GraphCutConstr.mexa64')))
        oldFolder = cd('./GCmex');
        compile_gc()
        cd(oldFolder);
    end

    % read an image
    im = im2double(imread('parrot.jpg'));
    sz = size(im);

    % cluster the image colors into k regions
    data = ToVector(im);
    %[idx1, c] = kmeans(data, k);
    idx   = zeros(sz(1),sz(2),'uint8');
    cen = [];
    srcCords = [];
    snkCords = [];
    k = 0;
    
    cords = [10,10,20,20];
    k = k+1;
    [idx,c] = addSrcSnk(im,idx,cords,k);
    cen = [cen; c];
    snkCords = [snkCords;cords];
    
    
    cords = [60,30,70,110];
    k = k+1;
    [idx,c] = addSrcSnk(im,idx,cords,k);
    cen = [cen; c];
    srcCords = [srcCords;cords];
    
    % calculate the data cost per cluster center
    Dc = zeros([sz(1:2) k],'single');
    for ci=1:k
        % use covariance matrix per cluster
        icv = inv(cov(data(idx==ci,:)));    
        dif = data - repmat(cen(ci,:), [size(data,1) 1]);
        % data cost is minus log likelihood of the pixel to belong to each
        % cluster according to its RGB value
        Dc(:,:,ci) = reshape(sum((dif*icv).*dif./2,2),sz(1:2));
    end

    % cut the graph

    % smoothness term: 
    % constant part
    Sc = ones(k) - eye(k);
    % spatialy varying part
    [Hc,Vc] = SpatialCues(im);

    gch = GraphCut('open', Dc, 10*Sc, exp(-Vc*5), exp(-Hc*5));
    [gch,L] = GraphCut('expand',gch);
    gch = GraphCut('close', gch);

    % show results
    segImg = im;
    
    %Seperate Src regions and Snk regions
    for i = 1:size(snkCords,1)
        cords    = snkCords(i,:);
        patch    = L(cords(1):cords(3),cords(2):cords(4));
        clsLabel = median(reshape(patch,[1,numel(patch)]));
        segImg(:,:,1) = segImg(:,:,1).*(~(L == clsLabel));
        segImg(:,:,2) = segImg(:,:,2).*(~(L == clsLabel));
        segImg(:,:,3) = segImg(:,:,3).*(~(L == clsLabel));
    end
    
    imwrite(segImg,'bOut.png');
    disp('Done');
end

%---------------- Aux Functions ----------------%
function v = ToVector(im)
    % takes MxNx3 picture and returns (MN)x3 vector
    sz = size(im);
    v = reshape(im, [prod(sz(1:2)) 3]);
    vv = v;
    %row major vs col major access variation
    v(:,1) = vv(:,3);
    v(:,3) = vv(:,1);
end

function [idx,cen] = addSrcSnk(img,idx,bBox,nCen)
    imgPatch = img(bBox(1):bBox(3),bBox(2):bBox(4),:);
    dt = ToVector(imgPatch);
    [is,cen] = kmeans(dt, 1);
    idx(bBox(1):bBox(3),bBox(2):bBox(4)) = nCen;
end

%-----------------------------------------------%
function [hC,vC] = SpatialCues(im)
    g = fspecial('gauss', [13 13], sqrt(13));
    dy = fspecial('sobel');
    vf = conv2(g, dy, 'valid');
    sz = size(im);

    vC = zeros(sz(1:2));
    hC = vC;

    for b=1:size(im,3)
        vC = max(vC, abs(imfilter(im(:,:,b), vf, 'symmetric')));
        hC = max(hC, abs(imfilter(im(:,:,b), vf', 'symmetric')));
    end
end
    