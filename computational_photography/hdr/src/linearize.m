
%Z(i,j,k)
%the pixel value of image k at location (i,j)

% B(k), the log delta of image k;

%l , the lamda to determine the smoothness

% w(z), weigthing function used for each intensity value.

%Returns
% g(z) the log exposure corresponding to pixel value at z
% logLij , the constant irradiance value
% script inspired by
%http://www.pauldebevec.com/Research/HDR/debevec-siggraph97.pdf
function [g,Lij] = linearize(img_stack,B,l,w)
    n = 256;
    Z = modify(img_stack,"jpg");
    
    A = zeros( size(Z,1) * size(Z,2)+ n + 1 , n + size(Z,1));
    b = zeros( size(A,1), 1);

    k = 1;
    
    for i=1:size(Z,1)
        for j=1:size(Z,2)
            wij = w( Z(i,j) / 255, 0,1, 0);
            A(k,Z(i,j)+1) = wij; A(k,n+i) = -wij; b(k,1) = wij * log(B(j));
            k=k+1;
        end
    end
       
    k = k + 1;

    for i=1: n-2
         A(k,i)=l * w( (i+1) / 255  ,0,1, 0); 
         A(k,i+1)= -2*l*w((i+1) /255 ,0,1, 0);
         A(k,i+2)=l *w( (i+1) / 255 ,0,1,  0);
         k= k+1;
    end
    
    
    x = A\b;
    g = x(1:n);
    Lij = x(n+1: size(x,1));
end


function img_matrix = modify(img_stack,format)
    img_matrix = [];
    for i = 1:size(img_stack)
        img_n = preprocess_img(img_stack(i),format);
        img_part = img_n(1:200:end, 1:200:end,:);
        img_reshape = reshape(img_part,[],1,3);
        img_matrix = [img_matrix,img_reshape];
    end
end







