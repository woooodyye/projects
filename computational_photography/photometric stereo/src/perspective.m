function G = perspective(B,f,w,h)
%    w = 431;
%    h = 369;
   B_g = permute(B, [2 1]);
   B_g = reshape(B_g,w,h,3);
  
   B_s = reshape(B_g,[],1);
%    reshape the image to get the gradient.
  [Fx, Fy] = gradient(B_g);

  B_u = reshape(Fx, [],1);
  B_v = reshape(Fy, [],1);
  
  f_p =(f /32) * w;
  
  P = [B_u.' * B_s, B_v.' * B_s, (-w/f_p) * (B_u .' * B_s) - (h/f_p) * (B_v.' * B_s) ];
  
  [~,~,V] = svds(P,3);
  x = V(:,end);
end


function B_s = skew_sym(B)
    B_n = reshape(B,[],1);
    A = [1]
end