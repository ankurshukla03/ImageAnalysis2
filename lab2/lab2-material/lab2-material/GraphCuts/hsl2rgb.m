function  [rC,gC,bC] = hsl2rgb(h, s, l)

    if(s == 0)
        rC = l;
        gC = l;
        bC = l; % achromatic
    else
        if(l < 0.5)
            q = l * (1 + s);
        else
            q = l + s - l * s;
        end

        p = 2 * l - q;

        rC = hue2rgb(p, q, h + 1/3);
        gC = hue2rgb(p, q, h);
        bC = hue2rgb(p, q, h - 1/3);
    end
    rC = uint8(round(rC *255));
    gC = uint8(round(gC *255));
    bC = uint8(round(bC *255));
end

