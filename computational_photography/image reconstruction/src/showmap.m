
function map = showmap(temp)

    c = jet();
    
    map = discretize(temp,32);
    
    mesh(map);
    
    colormap(c);
end