
function img_stack = focal_stack(img_n)
    img_stack = [];
    for d = -2:0.1:0.5
      img = refocus(img_n, 16,16,700,400,d);
      img_stack = cat(4,img_stack,img);
    end

end