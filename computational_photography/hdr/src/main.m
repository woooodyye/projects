w_uniform = @(x,Zmin,Zmax,tk) weight(x,Zmin,Zmax,"uniform",0);
w_gauss = @(x,Zmin,Zmax,tk) weight(x,Zmin,Zmax,"gaussian",0);
w_photon = @(x,Zmin,Zmax,tk) weight(x,Zmin,Zmax,"photon",tk);
w_tent = @(x,Zmin,Zmax,tk) weight(x,Zmin,Zmax,"tent",tk);
w_optimal = @(x,Zmin,Zmax,tk) weight(x,Zmin,Zmax,"optimal",tk);

% addpath('src');
tk = 1./2048 .* 2.^( [1,10,11,12,13,14,15,16,2,3,4,5,6,7,8,9] -1 );
tk = cast(tk,'double');

% tk_cam = [1/160, 1/80, 1/60,1/50,1/40,1/30,1/25,1/20,1/15,1/13,1/10,1/8,1/6,1/5];
% tk_cam = cast(tk_cam,'double');

L = dir('raw/*.tiff');
    images = strings(size(L));
    for i = 1 : size(L,1)
        name = strcat('raw/',L(i).name);
        images(i,1) = name; 
    end

% dcraw -w -o 1 -q 3 -4 -T DSC00694.ARW 
% img_hdr = hdr(images,tk, w_gauss, "jpg", "linear");
% [g,lij] = linearize(images,tk,1,w_uniform);

p1 = [3316,1418,3418,1526];
p2 = [3478,1418,3562,1514];
p3 = [3634,1418,3730,1514];
p4 = [3796,1418,3892,1514];
p5 = [3322,1256,3400,1358];
p6 = [3478,1262,3562,1358];
p7 = [3640,1256,3712,1346];
p8 = [3796,1262,3862,1352];
p9 = [3298,1094,3424,1220];
p10 = [3466,1094,3590,1220];
p11 = [3622,1094,3722,1220];
p12 = [3778,1094,3890,1220];
p13 = [3298,932,3424,1052];
p14 = [3466,932,3590,1052];
p15 = [3622,932,3722,1052];
p16 = [3778,932,3890,1052];
p17 = [3298,776,3424,883];
p18 = [3466,776,3590,883];
p19 = [3622,776,3722,883];
p20 = [3778,776,3890,883];

p21 = [3298,614,3424,715];
p22 = [3466,614,3590,715];
p23 = [3622,614,3722,715];
p24 = [3778,614,3890,715];

coordinates = [p1;p2;p3;p4;p5;p6;p7;p8;p9;p10;p11;p12;p13;p14;p15;p16;p17;p18;p19;p20;p21;p22;p23;p24];
% img = hdrread('data/hdr_tiff/gauss_linear_2.hdr');
% 
% img = img / 10000;
% affine = colorcorrect(img,coordinates);
% img_homo = cat(3,img,ones(size(img,1),size(img,2)));
% 
% img_homo = permute(img_homo,[3,2,1]);
% img_homo = reshape(img_homo,4,[]);
% img_new =   (affine .') * img_homo;
% img_new = reshape(img_new,3,size(img,2),size(img,1));
% img_new = permute(img_new,[3,2,1]);
% imshow( img_new );


