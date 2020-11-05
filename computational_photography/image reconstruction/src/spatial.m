
% maybe i should test them out. Might be a good idea.
% we have manually determine the part that is not occulded is <156 and >328
function [p1_vs,p2_vs,p1_hs,p2_hs] = spatial(frogs)

    I_max = max(frogs,[],3);

    I_min = min(frogs,[],3);
    
    I_shadow = (I_max + I_min) ./ 2;
    
    
%     find t for each frame
    delta_I = frogs - I_shadow;
    
%     
%         y1 = 156;
%     y2 = 328;

    y1 = 464;
    y2 = 932;
    
    p1_vs = [];
    p2_vs = [];
    p1_hs = [];
    p2_hs = [];
    
    
    
%     [ps3,ps4] = show_spatial(delta_I(:,:,50),1,y1);
%     [ps1,ps2] = show_spatial(delta_I(:,:,50),y2,size(delta_I,1));
    
    
    
    for i = 1:size(delta_I,3)
        
        i = 100;
        
        [p1_v,p2_v] = filter_spatial(delta_I(:,:,i),80,y1);
        [p1_h,p2_h] = filter_spatial(delta_I(:,:,i),y2,size(delta_I,1));
    
        p1_vs = cat(1,p1_vs,p1_v);
        p2_vs = cat(1,p2_vs,p2_v);
            
        p1_hs = cat(1,p1_hs,p1_h);
        p2_hs = cat(1,p2_hs,p2_h);
    end

end

function [v1,v2] = filter_spatial(delta_It,y1,y2)
%     ignore those with low contrast, threshold 30
    thre = 30 / 255;
    l1 = [];
    l2 = [];
    
%     y1 = 156;
%     y2 = 328;
    for i = y1:y2
        l = find(delta_It(i,:) < -thre);
        if isempty(l)
            continue;
        else
             x1 = min(l);
             p1 = [i,x1];             
             t2 = find(delta_It(i, l:end) > 0);   
             
             
             x2 = min(t2) + x1;  
             
             if isempty(x2)
                 x2 = y2;
             end
             p2 = [i,x2];
             
             l1 = cat(1,l1,p1);
             l2 = cat(1,l2,p2);
        end
    end
    
    if isempty(l1)
        v1 = [NaN,NaN];
        v2 = [NaN,NaN];
        ps1 = [];
        ps2 = [];
    else
      v1 = polyfit(l1(:,1),l1(:,2),1);
      ps1 = polyval(v1,l1(:,1));
      
      v2 = polyfit(l2(:,1),l2(:,2),1);
      ps2 = polyval(v2,l2(:,1));
    end
end


function [ps1,ps2] = show_spatial(delta_It,y1,y2)
%     ignore those with low contrast, threshold 30
    thre = 30 / 255;
    l1 = [];
    l2 = [];
    
%     y1 = 156;
%     y2 = 328;
    for i = y1:y2
        l = find(delta_It(i,:) < -thre);
        if isempty(l)
            continue;
        else
             x1 = min(l);
             p1 = [i,x1];             
             t2 = find(delta_It(i, l:end) > 0);   
             
             
             x2 = min(t2) + x1;  
             
             if isempty(x2)
                 x2 = y2;
             end
             p2 = [i,x2];
             
             l1 = cat(1,l1,p1);
             l2 = cat(1,l2,p2);
        end
    end
    
    if isempty(l1)
        v1 = [NaN,NaN];
        v2 = [NaN,NaN];
        ps1 = [];
        ps2 = [];
    else
      v1 = polyfit(l1(:,1),l1(:,2),1);
      ps1 = polyval(v1,l1(:,1));
      
      v2 = polyfit(l2(:,1),l2(:,2),1);
      ps2 = polyval(v2,l2(:,1));
    end
end




