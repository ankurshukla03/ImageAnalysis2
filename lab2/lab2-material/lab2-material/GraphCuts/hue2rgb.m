function hue2rgb = hue2rgb(pC, qC, tC)
    if(tC < 0) 
        tC = tC + 1;
    end
    if(tC > 1)
        tC = tC - 1;
    end
    
    hue2rgb =  pC;
    
    if(tC < 1/6)
        hue2rgb = pC + (qC - pC) * 6 * tC;
    else
    
        if(tC < 1/2)
            hue2rgb = qC;
        else
            if(tC < 2/3)
                hue2rgb =  pC + (qC - pC) * (2/3 - tC) * 6;
            end
        end
    end
end

