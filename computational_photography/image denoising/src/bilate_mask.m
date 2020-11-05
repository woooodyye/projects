
function img_final = bilate_mask(img_d, img_b,img_A,img_F,tau_s)
    M = mask(img_A,img_F, tau_s);
    img_final = (1 - M) .* img_d + M.* img_b;
end



function M = mask(img_A, img_F, tau_s)
    img_A = normalize(img_A);
    img_F = normalize(img_F);
    M_shadow = zeros(size(img_A));
    M_shadow(img_F - img_A <= tau_s ) = 1;
    M_flash = zeros(size(img_A));
    %need to change it to luminance value.
    %because img_F is normalized.
    M_flash(img_F>0.95) = 1;
    
    M = M_shadow | M_flash;
end
