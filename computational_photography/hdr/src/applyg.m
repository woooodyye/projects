function img_new = applyg(file,g)
    img = preprocess_img(file,'jpg'); 
%     img(img>255) = 255;
    img(img<0) = 0;
    %clipping
    img_new = exp(g(img+1));
end