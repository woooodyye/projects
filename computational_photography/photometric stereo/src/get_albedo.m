function A_e = get_albedo(B_e,w,h)
        A_e = vecnorm(B_e);
        
        A_e = reshape(A_e,w,h);
%       A_e = sqrt(sum(B_e .^ 2 ,1));
%       A_e = reshape(A_e, w, h);
%         
end