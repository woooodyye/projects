images = [];
addpath('src');
% addpath('../photometric/lamb/')
% 
for i = 1:7
    img = "data/input_" + string(i) + ".tif";
    image = im2double(imread(img));
    img_xyz = rgb2xyz(image,'ColorSpace','linear-rgb');
    img_lum = img_xyz(:,:,2);
    img_v = reshape(img_lum,1,[]);
    images = cat(1,images,img_v);
end

% for i = 1:7
%     img = "../photometric/SPEC/DSC1" + string(i) + ".tiff";
%     image = im2double(imread(img));
%     image = imresize(image,0.06);
% %     image = image(400:end,400:end-400,:);
% %     image = imresize(image,0.6);
%     img_xyz = rgb2xyz(image,'ColorSpace','linear-rgb');
%     img_lum = img_xyz(:,:,2);
%     img_v = reshape(img_lum,1,[]);
%     images = cat(1,images,img_v);
% end