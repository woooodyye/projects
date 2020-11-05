function L = new_light(B_e,l,w,h)
%     A = get_albedo(B);
%     N = get_norm(B);
%     

      A_e = sqrt(sum(B_e .^ 2 ,1));
      
      N_e = B_e ./ repmat(A_e, [3,1]);
     
%       N_e = permute(N_e,[2 1]);
%         
%       N_e = reshape(N_e,w,h,3);
%       
%       A_e = reshape(A_e, w, h);

      ndotl = l * N_e;
        
      N_e = (N_e +1 ) ./ 2;
      
     L = max(0,A_e .* ndotl);
     
     L = permute(L, [2,1]);
     L = reshape(L,w,h);
end