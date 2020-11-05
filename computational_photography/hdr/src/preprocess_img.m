function img_norm = preprocess_img(file,format)
%     img = imread(file,'PixelRegion',{[1,2],[2,5]} );
    img = imread(file,char(format));
    img = cast(img, 'double');
    
    if format == "tiff"
%         img_norm = img ./ 65535;
          img_norm = img;
          
    else
%         img_norm = img ./ 255;
          img_norm = img;
    end
end
