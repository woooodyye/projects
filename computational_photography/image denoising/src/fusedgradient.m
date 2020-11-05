function img = fusedgradient(fused,Gx,Gy,img_A)
    fused = normalize(fused);
    img_A = normalize(img_A);

    fused = reshape(fused,[],1);


    G_xx = diff(Gx);
    padding_x = zeros(1,size(Gx,2));
    padding_y = zeros(size(Gx,1),1);
    
    G_xx = cat(1,G_xx,padding_x);
    
    G_yy = diff(Gy,1,2);
    G_yy = cat(2,G_yy,padding_y);
    
    div_g = G_xx + G_yy;
    
    
    
    div_gv = reshape(div_g,[],1);
    

    r_0 = div_gv -  lf(fused,size(img_A,1));
    
    d_0 = r_0;
    
    r_i = r_0;
    d_i = d_0;
    
    fused_i = fused;
    
    count = 0;
    while count < 200
        
        [r_i,d_i,fused_i] = descent(img_A,r_i,d_i,fused_i,div_gv);
        count = count + 1;
    end    
    
    img = reshape(fused_i,size(img_A,1),[]); 
    
end


function [r_i1,d_i1,fused_i1] = descent(img_A,r_i,d_i,fused_i,div_g)

    d_i = set_boundary(d_i,zeros(size(img_A)));
    
    n_i = dot(d_i,r_i) ./ dot(d_i, lf(d_i,size(img_A,1))) ;
   
    
    fused_i = set_boundary(fused_i,img_A);
    
    
    fused_i1 = fused_i + n_i .* d_i ; 
    
    
    r_i1 = div_g - lf(fused_i1,size(img_A,1));
    
    b_i1 = dot(r_i1,r_i1) ./ dot(r_i, r_i)  ;
    
    d_i1 = r_i1 + b_i1 .* d_i;
    
end

function laplac = lf(img,s)

    l_filter = fspecial('laplacian',0);
    
    laplac = conv2(reshape(img,s,[]),l_filter,'same');
    laplac = reshape(laplac,[],1);

end


function img_fused = set_boundary(img_fused, img_ref)
    img_fused = reshape(img_fused,size(img_ref,1),[]);
    
    img_fused(1,1:end) = img_ref(1,1:end);
    img_fused(1:end,1) = img_ref(1:end, 1);
    img_fused(end,1:end) = img_ref(end,1:end);
    img_fused(1:end,end) = img_ref(1:end,end);
    
    img_fused = reshape(img_fused,[],1);
end