%gamma correction 
function img_corrected = gamma_correct(img_rgb)
    img_rgb = adjust_brightness(img_rgb);
    img_rgb(img_rgb >= 0.0031308) = (1 + 0.055) .* img_rgb(img_rgb >= 0.0031308) .^(1.0 ./2.4) - 0.055;
    img_rgb(img_rgb < 0.0031308) = 12.92 .* img_rgb(img_rgb < 0.0031308);
    img_corrected = img_rgb;
end

function img_adjust = adjust_brightness(img_rgb)
    img_gray = rgb2gray(img_rgb);
    max_gray = max(reshape(img_gray,[],1));
    S = 1;
    ratio = S * max_gray;
    img_adjust = ratio .* img_rgb;
end

