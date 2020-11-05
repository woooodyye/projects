
function w = weight(a,Zmin,Zmax,model,tk)

    logical = (a >= Zmin) &  (a<= Zmax);
%     logical = 1;
    if model == "uniform"
        w =  logical;
        
    elseif model == "gaussian"
        b = exp(-4 .* (a - 0.5).^2  ./ (0.5^2)) ;
        w = logical .* b;
        
    elseif model == "tent"
        w = logical .* min(a,1-a);
    elseif model == "photon"
        w = logical .* tk; 
    elseif model == "optimal"
        b = (tk .^2) ./ (19.42 .* a + 7873);
        w = logical .* b;
    end
            
end

