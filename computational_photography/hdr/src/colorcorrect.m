

function img_corrected = colorcorrect(img_hdr,coordinates)
    affine = get_affine(img_hdr,coordinates);
    
    img_homo = cat(3,img_hdr,ones(size(img_hdr,1),size(img_hdr,2)));
    img_homo = permute(img_homo,[3,2,1]);
    img_homo = reshape(img_homo,4,[]);
    img_corrected =   (affine .') * img_homo;
    img_corrected = reshape(img_corrected,3,size(img_hdr,2),size(img_hdr,1));
    img_corrected = permute(img_corrected,[3,2,1]);
    img_corrected(img_corrected < 0) = 0;
    %p4 = [3796,1418,3892,1514];
    [G_ratio, B_ratio] = wb(img_corrected,3796,1418,3892,1514);
    disp(G_ratio);
    disp(B_ratio);
    img_corrected(:,:,2) = G_ratio .* img_corrected(:,:,2);
    img_corrected(:,:,3) = B_ratio .* img_corrected(:,:,3);
end



function affine_matrix = get_affine(img_hdr,coordinates)
    %get all 24 patches.
    %calculate average rgb coordinates;
    %add 1 to each matrix, transpose, make it 4x1
    %apply it to the matrix
    A = [];
    for i = 1:24
        x1 = coordinates(i,1);
        x2 = coordinates(i,3);
        y1 = coordinates(i,2);
        y2 = coordinates(i,4);
        hom_rgb = ave_rgb(img_hdr,x1,y1,x2,y2);
        A = [A, hom_rgb];
    end
    [r,g,b]=read_colorchecker_gm();
    rgb_array = cat(3,r,g,b);
    rgb_array = reshape(rgb_array,1,24,3);
%     rgb_array = permute(rgb_array,[2,1,3]);
    rgb_346 = permute(rgb_array,[3,2,1]);
    B = reshape(rgb_346,3,24);
    affine_matrix = (A.') \ (B.');
end

function [G_ratio, B_ratio] = wb(img_cc, x1,y1,x2,y2)
    red = img_cc(y1:y2,x1:x2,1);
    green = img_cc(y1:y2, x1:x2, 2);
    blue = img_cc(y1:y2, x1:x2, 3);
    r = mean(reshape(red,[],1));
    g = mean(reshape(green,[],1));
    b = mean(reshape(blue,[],1));
    G_ratio = r ./ g;
    B_ratio = r ./ b;
end

function hom_rgb = ave_rgb(img_hdr,x1,y1,x2,y2)
    red = img_hdr(y1:y2,x1:x2,1);
    green = img_hdr(y1:y2, x1:x2, 2);
    blue = img_hdr(y1:y2, x1:x2, 3);
    r = mean(reshape(red,[],1));
    g = mean(reshape(green,[],1));
    b = mean(reshape(blue,[],1));
    hom_rgb = transpose([r,g,b,1]);
end