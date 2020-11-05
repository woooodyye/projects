function [xoffSet,yoffSet] = template_matching(I, template)
% subtract each pixel of the template from the mean, 
%convolve the window with the subtacted template, subtract the result;

% bottom part the sum is the scalar 
% top part is the convolution patch
    I_xyz = rgb2xyz(I,'ColorSpace','linear-rgb');
    I_lum = I_xyz(:,:,2);
    
    template_xyz=rgb2xyz(template,'ColorSpace','linear-rgb');
    template_lum = template_xyz(:,:,2);
    
    t_m = mean(template_lum(:));
    template_n = template_lum - t_m;
    
    h_box = fspecial('average',size(template_n));
    
    I_filtered = imfilter(I_lum,h_box,'same');
    
    I_m = I_lum - I_filtered;
    I_top = imfilter(I_m,template_n,'same');
    
    
    I_sq = I_m .^2 ;
    
    I_bot = imfilter(I_sq,h_box,'same');
    
    c_bot = sum( template_n(:).^2 );
    
    I_bot = c_bot .* I_bot;
    
    h = I_top ./ sqrt(I_bot);
    
    c = normxcorr2(template_lum,I_lum);
    
    
    [y_peak,x_peak] = find(h ==max(h(:)),1);
    
    yoffSet = y_peak-size(template,1)/2;
    xoffSet = x_peak-size(template,2)/2;

end