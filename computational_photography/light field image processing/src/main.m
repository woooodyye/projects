
img = imread('data/chessboard_lightfield.png');
w = size(img,1);
h = size(img,2);
img_new = zeros (16,16,h/16,w/16,3);
for i = 1:3
    img_c = img(:,:,i);
    
    img_uvst = touvst(img_c,16,16,w/16, h/16);
    
    img_new(:,:,:,:,i) = img_uvst;
end

function img_4d = to4(img,u,v,s,t)
    img_4d = im2col(img,[u,v],'distinct');
    img_4d = reshape(img_4d,u,v,s,t);
end
