
function [G_x,G_y] = observedeck(img_A,img_F,sigma, tau)
    
    [G_Hprojx, G_Hprojy,G_Hx,G_Hy] = gradient_map(img_A, img_F);
    
    W_ue = 1 - saturation_map(img_F, sigma, tau);
    
    
    G_x = W_ue .* G_Hx + (1 - W_ue) .* (G_Hprojx);
    
    G_y = W_ue .* G_Hy + (1 - W_ue) .* (G_Hprojy);
end


%create fused gradient domain 
function [G_xproj,G_yproj,G_xh,G_yh] = gradient_map(img_A, img_F)
%I have to do it for three layers.
    img_A = cast(img_A,'double');
    img_F = cast(img_F,'double');
    
    img_A = normalize(img_A);
    img_F = normalize(img_F);
    
    
    img_H = img_A + img_F;

    G_xa = diff(img_A);
    
    padding_x = zeros(1,size(img_A,2));
    padding_y = zeros(size(img_A,1),1);
    
    G_xh = diff(img_H);
    
    G_xa = cat(1,G_xa,padding_x);
    G_xh = cat(1,G_xh,padding_x);
    
    
    G_ya = diff(img_A,1,2);
    G_yh = diff(img_H,1,2);
    
    G_ya = cat(2,G_ya,padding_y);
    G_yh = cat(2,G_yh,padding_y);
    
    G_a = cat(2,reshape(G_xa,[],1),reshape(G_ya,[],1));
    
    G_h = cat(2,reshape(G_xh,[],1),reshape(G_yh,[],1));
    
    
    
    M_top = dot(G_a,G_h,2);
    M_bot = vecnorm(G_a,2,2) .* vecnorm(G_a,2,2);
    
    M = M_top ./ M_bot;
    
    
    M(isnan(M)) = 0;
      
    M = reshape(M,size(img_A,1),[]);
    
    G_xproj = G_xa .* M;
    G_yproj = G_ya .* M;
    
end


function M_sat = saturation_map(img_f,sigma,tau)
    img_n = normalize(img_f);
    M_sat = tanh(sigma .* (img_n - tau));
    M_sat = normalize(M_sat);
end


