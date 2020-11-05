% B_e is 3x n 
function N_e = get_norm(B_e,w,h)
        
      A_e = sqrt(sum(B_e .^ 2 ,1));
      
      N_e = B_e ./ repmat(A_e, [3,1]);
     
      N_e = permute(N_e,[2 1]);
        
      N_e = reshape(N_e,w,h,3);
      
      A_e = reshape(A_e, w, h);
        
      N_e = (N_e +1 ) ./ 2;
end