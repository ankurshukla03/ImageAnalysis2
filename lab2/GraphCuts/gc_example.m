function gc_example()
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

    % try to segment the image into k different regions
    % you can change this parameter and check the results
    k = 2;

    % cluster the image colors into k regions
    data = ToVector(im);
    [idx,c] = kmeans(data, k);

    % calculate the data cost per cluster center
    Dc = zeros([sz(1:2) k],'single');
    for ci=1:k
        % use covariance matrix per cluster
        icv = inv(cov(data(idx==ci,:)));    
        dif = data - repmat(c(ci,:), [size(data,1) 1]);
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
    
    % Dc --> Graph node labeling cost 
    % 10*Sc --> Graph node change 
    % exp(-Vc*5), exp(-Hc*5) --> Graph edge cost
    gch = GraphCut('open', Dc, 10*Sc, exp(-Vc*5), exp(-Hc*5));
    [gch,L] = GraphCut('expand',gch);
    gch = GraphCut('close', gch);

    % show results
    segImg = zeros(size(L,1), size(L,2),3,'uint8');
    xx=unique(L);
    nidx = numel(xx);
    clr =0.0;
    for i = 1:nidx
        if(k==2)
            [R,G,B] = hsl2rgb(0,0.0,clr);
        else
            [R,G,B] = hsl2rgb(clr/double(nidx),1.0,0.5);
        end
        clr = clr +1.0;
        disp(R);disp(G);disp(B);
        mask = uint8(L==xx(i));
        segImg(:,:,1) = segImg(:,:,1) + mask*R;
        segImg(:,:,2) = segImg(:,:,2) + mask*G;
        segImg(:,:,3) = segImg(:,:,3) + mask*B;
    end
    imwrite(segImg,'gcOut.png');
    disp('Done');
end


%---------------- Aux Functions ----------------%
function v = ToVector(im)
    % takes MxNx3 picture and returns (MN)x3 vector
    sz = size(im);
    v = reshape(im, [prod(sz(1:2)) 3]);
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
    