
function img = suba(img_5d)
   [u,v,s,t,c] = size(img_5d);
   img = zeros(u*s,v*t,c);
   for i = 1:c
       img_4d = img_5d(:,:,:,:,i);
       img_2d = to2(img_4d,u,v,s,t);
       img(:,:,i) = img_2d;
   end
end


function img_2d = to2(img_4d,u,v,s,t)
    c  =permute(img_4d,[3 4 1 2]);
    img_2d = zeros(u*s,v*t);
    for i = 1:u
        for j = 1:v
            x = s* i - (s-1);
            y = t* j - (t-1);
            s1 = c(:,:,i,j);
            s1 = reshape(s1,s,t);
            img_2d(x:x+s-1,y:y+t-1) = s1;
        end
    end
    
end