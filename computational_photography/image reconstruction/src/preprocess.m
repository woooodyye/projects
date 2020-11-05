
function img_stack = preprocess(frame)
img_stack = [];

for i = 1:3:size(frame,4)
    
    img = frame(:,:,:,i);
    img = im2double(img);
    img_gray = rgb2gray(img);
    img_stack = cat(3,img_stack,img_gray);
end

end