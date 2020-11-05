function B_e = uncalibrated(I,w,h)
%         w = 1666;
%         h = 36;

        
      [L,s,B] = svd(I,'econ');
      s(4:end,4:end) = 0;
      L_new = L * sqrt(s);
      L_e = L_new(:,1:3);
      B_new = sqrt(s) * (B.');
      B_e = B_new(1:3,:);
      
      A_e = sqrt(sum(B_e .^ 2 ,1));
      
      N_e = B_e ./ repmat(A_e, [3,1]);
     
      N_e = permute(N_e,[2 1]);
        
      N_e = reshape(N_e,w,h,3);
      
      A_e = reshape(A_e, w, h);
        
      N_e = (N_e +1 ) ./ 2;
      
% 
%         A_e = vecnorm(B_e);
% 
%         N_e = B_e ./ A_e;
%         
%         A_e = reshape(A_e,w,h);
%         
%         N_e = permute(N_e,[2 1]);
%         
%         N_e = reshape(N_e,w,h,3);
%         
%         N_e = (N_e +1 ) ./ 2;
end