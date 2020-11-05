function img_D = detail_tf(img_F,img_jb,s,sigma_s,sigma_r) 
    img_F = normalize(img_F);
    F_base = bilateral(img_F,s,sigma_s,sigma_r);
    eps = 0.001;
    img_D = img_jb .* (img_F + eps) ./ (F_base + eps);
end