function images = pre_video(v,g)

%     v= VideoReader('global/tide.mp4');
    frame = read(v);
    
%     img_stack = preprocess(f);
    
    images= [];
    for i = 1:3:size(frame,4)

        img = frame(:,:,:,i);
        img = applyg(img,g);
        img = im2double(img);
        img_gray = rgb2gray(img);
        images = cat(3,images,img_gray);
    end
end
function img_new = applyg(img,g)
%     img = preprocess_img(file,'jpg'); 
%     img(img>255) = 255;
    img(img<0) = 0;
    %clipping
    img_new = exp(g(img+1));
end