

function img_a = lightfield(frames,template)
    frame_new = [];
    for i = 1:40
        frame = frames(:,:,:,i);
        
        window = frame(700:1200,300:800,:);
        [x_peak,y_peak] = template_matching(window,template);
        
        if i==1
            x = x_peak;
            y = y_peak;
        else
            
        end
        frame_shift = imtranslate(frame,[x-x_peak ,y-y_peak],'linear','FillValues',0);
        frame_new = cat(4,frame_new,frame_shift);
        
    end
    
    img_a = mean(frame_new,4);
end


