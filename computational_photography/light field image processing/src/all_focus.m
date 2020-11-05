

function img_all = all_focus(focal_stack,sigma1,sigma2,flag)

    weights = [];
    w_top = [];
    for i = 1:size(focal_stack,4)
        img = focal_stack(:,:,:,i);
        w = sharpness(img,sigma1,sigma2);
        weights = cat(3,weights,w);
        
        if flag == "all_focus" 
            w_top = cat(4,w_top, w.* img);
        else
            w_top = cat(4,w_top, w.* i*0.1 );
        end
    end
    img_all = sum(w_top, 4) ./ sum(weights,3);
end


function weight = sharpness(img,sigma1,sigma2)
    img_xyz = rgb2xyz(img,'ColorSpace','linear-rgb');
    img_lum = img_xyz(:,:,2);
    img_low = imgaussfilt(img_lum,sigma1);
    img_high = img_lum - img_low;
    weight = imgaussfilt((img_high).^2, sigma2);
end

function d_map = depth(focal_stack,sigma1,sigma2)
    i = 1:size(focal_stack);
    weight = sharpness(img(i),sigma1,sigma2);
    d_map = sum(weight .* (-2+(i-1).*0.1)) ./ sum(weight);
end