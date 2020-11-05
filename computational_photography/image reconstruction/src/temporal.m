
function [t1,t2] = temporal(frogs)

    I_max = max(frogs,[],3);

    I_min = min(frogs,[],3);
    
    I_shadow = (I_max + I_min) ./ 2;
    
%     ignore those with low contrast, threshold 30

    
%     find for each 
    delta_I = frogs - I_shadow;
    
    
    [t1,t2] = filter_temp(delta_I);
    

end


function [t1,t2] = filter_temp(delta_I)
    t1 = zeros(size(delta_I,1),size(delta_I,2));
    t2 = zeros(size(delta_I,1),size(delta_I,2));
    thre = 30 / 255;
    for i = 1:size(delta_I,1)
        for j = 1:size(delta_I,2)
            t = find(delta_I(i,j,:) < -thre);
            if isempty(t)
                continue;
            else
                t1ij = min(t);
                t2ij = max(t);
                
                t1(i,j) = t1ij;
                t2(i,j) = t2ij;
            end
        end
    end
end


