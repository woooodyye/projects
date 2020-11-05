
function [G_x,G_y] = create_grad(img_A,img_F,sigma, tau)
    
    [M,G_xa,G_ya,G_xf,G_yf] = gradient_map(img_A, img_F);
    W_s = saturation_map(img_F, sigma, tau);
    
    G_x = W_s .* G_xa + (1 - W_s) .* (M .* G_xf + (1 - M) .* G_xa);
    
    G_y = W_s .* G_ya + (1 - W_s) .* (M .* G_yf + (1 - M) .* G_ya);
end


%create fused gradient domain 
function [M,G_xa,G_ya,G_xf,G_yf] = gradient_map(img_A, img_F)
%I have to do it for three layers.
    img_A = cast(img_A,'double');
    img_F = cast(img_F,'double');
    
%     img_A = normalize(img_A);
%     img_F = normalize(img_F);

    G_xa = diff(img_A);
    padding_x = zeros(1,size(img_A,2));
    padding_y = zeros(size(img_A,1),1);
    
    G_xf = diff(img_F);
    
    G_xa = cat(1,G_xa,padding_x);
    G_xf = cat(1,G_xf,padding_x);
    
    
    G_ya = diff(img_A,1,2);
    G_yf = diff(img_F,1,2);
    
    G_ya = cat(2,G_ya,padding_y);
    G_yf = cat(2,G_yf,padding_y);
    
    G_a = cat(2,reshape(G_xa,[],1),reshape(G_ya,[],1));
    
    G_f = cat(2,reshape(G_xf,[],1),reshape(G_yf,[],1));
    
    
    
    M_top = dot(G_a,G_f,2);
    M_bot = vecnorm(G_a,2,2) .* vecnorm(G_f,2,2);
    
    M = M_top ./ M_bot;
    
    M(isnan(M)) = 0;
      
    M = reshape(M,size(img_A,1),[]);
    
end


function M_sat = saturation_map(img_f,sigma,tau)
    img_n = normalize(img_f);
    M_sat = tanh(sigma .* (img_n - tau));
    M_sat = normalize(M_sat);
end


