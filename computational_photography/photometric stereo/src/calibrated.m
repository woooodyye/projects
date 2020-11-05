function [B_c,N_c,A_c] = calibrated(I,L)
   
    B_c = L \ I ;
    
        mu = 0;
    v = 0;
    lambda= -1;
    G = [1, 0 , 0 ; 0 , 1 , 0; mu, v, lambda];
    
    B_c = (inv(G)).' * B_c;
    
    N_c = get_norm(B_c);
    
    A_c = get_albedo(B_c);
    
    Depth = normalize(A_c);
end


function N = normalize(img)
    img = cast(img,'double');
    max_v = max( reshape(img,[],1));
    min_v = min(reshape(img,[],1));
    scale = max_v - min_v;
    N = (img - min_v ) ./ scale;
end