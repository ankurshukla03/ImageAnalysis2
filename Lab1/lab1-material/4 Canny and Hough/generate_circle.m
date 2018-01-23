%GENERATE_CIRCLE(imsize,radius,position) 
%
%   GENERATE_CIRCLE, creates a 2D mask image with size specified by imsize.
%   A binary circle is placed with a defined center position and radius.
%
%   Examples:
%      imshow(generate_circle([300 300],70,[150 150]),[])
%
%   Written by: Gustaf and Patrik, Nov 2010

function circle = generate_circle(imsize,radius,pos)

I = zeros(imsize(1),imsize(2));
I(pos(1),pos(2)) = 1;
D = bwdist(I,'euclidean');
circle = D <= radius;
circle = circle - imerode(circle,strel('disk',1,0));