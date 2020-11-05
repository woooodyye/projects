
function img_hdr = hdr(img_stack,tk_stack,w_func,format,method)
    W_sum = zeros(size(img_stack(1))); 
    B_sum = zeros(size(img_stack(1))); 
    for i = 1:size(img_stack)
        img_n = preprocess_img(img_stack(i),format);
        if method == "linear"
            [A,B] = linear_stack(img_n,tk_stack(i),w_func);
        elseif method == "log"
            [A,B] = log_stack(img_n, tk_stack(i),w_func);
        end
        W_sum = W_sum + A;
        B_sum = B_sum + B;
    end
    if method == "linear"
        img_hdr = W_sum ./ B_sum;
    elseif method == "log"
        img_hdr = exp(W_sum  ./ B_sum);
    end
    img_hdr(isnan(img_hdr)) = 0;
end

%linear hdr stacking

%assuming i have a list of matrix object
function [wtop,wbot] = linear_stack(img,tk,w_func)
    Zmin = 655;
    Zmax = 64879;
    wtop = (w_func(img , Zmin,Zmax,tk) .* img) ./ tk;
    wbot = w_func(img , Zmin,Zmax,tk);
end 



%logrithmic hdr stacking
function [wtop,wbot] = log_stack(img, tk, w_func)
    Zmin = 0.01;
    Zmax = 0.99;
    img(img<Zmin) = 1;
    wtop = w_func(img,Zmin,Zmax,tk) .* (log(img) - log(tk));
    wbot = w_func(img,Zmin,Zmax,tk);
end




