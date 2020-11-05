function img_tm = tonemapping(img_hdr, K, B, colorspace)
    if colorspace == "RGB"
          img_tm = tonemap(img_hdr,K,B);
        
    elseif colorspace == "xyY"
        %convert piato XYZ space.
        img_xyz = rgb2xyz(img_hdr, 'ColorSpace','linear-rgb');
        %convert to xyY space
        img_X = img_xyz(:,:,1);
        img_Y = img_xyz(:,:,2);
        img_Z = img_xyz(:,:,3);
        cx = img_X ./ (img_X + img_Y + img_Z);
        cy = img_Y ./ (img_X + img_Y + img_Z);
        luminance = img_Y;
        Y_tm = tonemap(luminance,K,B);
        %revert back to XYZ;
        [X,Y,Z] = xyY_to_XYZ(cx,cy,Y_tm);
        %use matlab builtin to rgb;
        img_xyz_tm = cat(3,X,Y,Z);
        img_tm = xyz2rgb(img_xyz_tm,'ColorSpace','linear-rgb');
    end
end


function img_tm = tonemap(img_hdr, K,B)
    I_m = imean(img_hdr);
    I_tilde = tilde(img_hdr,I_m, K);
    I_white = iwhite(I_tilde,B);
    img_tm =(I_tilde .* (1 + I_tilde./ (I_white.^2) ) ) ./ (1 + I_tilde);
end


function I_m = imean(img_hdr)
    img = img_hdr(:);
    ep = 1e-3;
    logr = log(img+ ep);
    logr(isnan(logr)) = 0;
    logr(isinf(logr)) = 0;
    I_m = exp( mean(logr));
end

function I_white = iwhite(I_tilde,B)
    img = I_tilde(:);
    I_white = B * max(img);
end

function I_tilde = tilde(img_hdr, I_m,K)
    I_tilde = (K./I_m) .* img_hdr;
end
