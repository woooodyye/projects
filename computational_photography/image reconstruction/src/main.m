% load the picture sequence into a matrix array



addpath('src');
addpath('data');
% 


frog = dir('data/assign6 source/*.jpg');

frog_dir = "data/frog/v1-lr/";

frog_stack = [];
for i = 1: size(frog,1)
    frog_seq = frog_dir + frog(i).name;
    frog_img = imread(frog_seq);
    frog_img = im2double(frog_img);
    frog_gray = rgb2gray(frog_img);
%     normalized
    frog_stack = cat(3,frog_stack,frog_gray);
end

[t1,t2] = temporal(frog_stack);
[p1_vs,p2_vs,p1_hs,p2_hs] = spatial(frog_stack);
[vns,ps] = calib_plane(p1_vs , p1_hs);
pts = recons(t1,vns,ps);
ptCloud = pointCloud(pts);

%