
function img_refocus = refocus(img_uvst,u,v,s,t,d)
   img_refocus = zeros(t,s,3);
   
    lensletSize = 16;
    maxUV = (lensletSize - 1) / 2;
    u_n = (1:lensletSize) - 1 - maxUV;
    v_n = (1:lensletSize) - 1 - maxUV;
    
   
   for c = 1:3
    img_c = img_uvst(:,:,:,:,c);
    
    img_i = [];
    
    for i = 1:16
        img_n = [];
        for j = 1:16
          img_a = img_c(i,j,:,:);
          img_a = reshape(img_a,s,t);
          img_a = imtranslate(img_a,[u_n(i) .* d, -(v_n(j) .* d)],'linear','FillValues',0);
%         I can reshape here and create 700x400,concat them in a list, get
%         mean, do it again for u 
          img_n = cat(3,img_n,img_a);
        end
        img_j = mean(img_n,3);
        img_i = cat(3,img_i,img_j);
    end
    img_re = mean(img_i,3);
    img_re = permute(img_re,[2,1]);
    img_refocus(:,:,c)= img_re;
    
   end
end