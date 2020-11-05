% function b = test(a)
%     b = im2col(a,[2,2],'distinct');
%     b = reshape(b,2,2,3,4);
% end

% function d = test(b)
%     c  =permute(b,[3 4 1 2]);
%     d = zeros(6,8);
%     s= 3;
%     t = 4;
%     for i = 1:2
%         for j = 1:2
%             x = s* i - (s-1);
%             y = t* j - (t-1);
%             s1 = c(:,:,i,j);
%             s1 = reshape(s1,3,4);
%             d(x:x+s-1,y:y+t-1) = s1;
%         end
%     end
%     
% end


% function b = test(a)
%     a1 = im2col(a,[2,2],'distinct');
%     a2 = reshape(a1,4,3,[]);
%     a3 = reshape(a2,2,2,[]);
%     a4 = reshape(a3,2,2,3,4);
%     a5 =permute(a4,[1,2,4,3]);
%     b = a5;
% end


function img = test(img_c,d)
    lensletSize = 16;
    maxUV = (lensletSize - 1) / 2;
    u_n = (1:lensletSize) - 1 - maxUV;
    v_n = (1:lensletSize) - 1 - maxUV;
    
    img_t = imtranslate(img_c,[7.5 .* d, 7.5 .*d ],'linear','FillValues',0);
end