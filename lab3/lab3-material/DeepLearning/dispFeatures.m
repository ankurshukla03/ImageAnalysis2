%%++++ display features from network
function dispFeatures(net,layers,channels,iter)
switch nargin
        case 3
            for layer = layers
                Img = deepDreamImage(net,layer,channels, ...
                    'PyramidLevels',1);
                figure;
                montage(Img);
                name = net.Layers(layer).Name;
                title(['Layer ',name,' Features']);
            end
        case 4
            for layer = layers
                Img = deepDreamImage(net,layer,channels, ...
                    'NumIterations',iter);
                figure;
                montage(Img);
                name = net.Layers(layer).Name;
                title(['Layer ',name,' Features']);
            end
end
