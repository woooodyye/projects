

% function img_bilat = main(img_A,sigma_s,sigma_r)
%     img_A = cast(img_A,'double');
%     
%     img_bilat = zeros( size(img_A) );
%     s = sigma_s * 2;
%     for i = 1:3
%         img_bilat(:,:,i) = bilateral(img_A(:,:,i),s,sigma_s,sigma_r);
%     end
% end

% 

% function img_joint = main(img_A,img_F,sigma_s,sigma_r)
%     img_A = cast(img_A,'double');
%     img_F = cast(img_F,'double');
%     img_joint = zeros( size(img_A) );
%     s = sigma_s * 2;
%     for i = 1:3
%         img_joint(:,:,i) = jointbilat(img_A(:,:,i),img_F(:,:,i),s,sigma_s,sigma_r);
%     end
% end

% 


% function img_detail = main(img_NR,img_F,sigma_s,sigma_r)
%     img_NR = cast(img_NR,'double');
%     img_F = cast(img_F,'double');
%     s = sigma_s * 2;
%     img_detail = zeros(size(img_NR));
%     for i = 1:3
%          img_detail(:,:,i) = detail_tf(img_F(:,:,i),img_NR(:,:,i),s,sigma_s,sigma_r); 
%     end
% end

% 
% function img_final = main(img_d, img_b,img_A,img_F,tau_s)
%     img_A = cast(img_A,'double');
%     img_F = cast(img_F,'double');
%     img_final = zeros(size(img_d));
%     for i =1 : 3
%         img_dd = img_d(:,:,i);
%         img_bb = img_b(:,:,i);
%         img_AA = img_A(:,:,i);
%         img_FF = img_F(:,:,i);
%         img_final(:,:,i) = bilate_mask(img_dd, img_bb,img_AA,img_FF,tau_s);
%     end
% end


% 
% function [Gx,Gy] = main(img_A,img_F,sigma,tau)
%     Gx = zeros(size(img_A));
%     Gy = zeros(size(img_A));
%     Gxf = zeros(size(img_A));
%     Gyf = zeros(size(img_A));
%     
%     for i = 1 : 3
%         [Gx(:,:,i), Gy(:,:,i)] = create_grad(img_A(:,:,i),img_F(:,:,i),sigma, tau);
%     end
% end

% function [Gx,Gy] = main(img_A,img_F,sigma,tau)
%     Gx = zeros(size(img_A));
%     Gy = zeros(size(img_A));
%     
%     for i = 1 : 3
%         [Gx(:,:,i), Gy(:,:,i)] = observedeck(img_A(:,:,i),img_F(:,:,i),sigma, tau);
%     end
% end


function img = main(fused,img_A,Gx,Gy)
    img = zeros(size(img_A));
    for i = 1:3
        img(:,:,i) = fusedgradient(fused(:,:,i),Gx(:,:,i),Gy(:,:,i),img_A(:,:,i));
    end
end