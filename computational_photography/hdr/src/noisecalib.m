function [M,sigma] = noisecalib(img_stack,format,x1,y1,x2,y2)
    %2678,878,6150,4950
    M = compute_mean(img_stack,format,x1,y1,x2,y2);
    sigma = compute_variance(img_stack,M,format,x1,y1,x2,y2);
end


function points = compute_val(img_stack,format,x1,y1,x2,y2)
    points = [];
    for i = 1:size(img_stack)
       img_n = preprocess_img(img_stack(i),format);
       img_p =img_n(y1 + 1000,x1+ 1000);
       points = [points; img_p];
    end
end

function M = compute_mean(img_stack,format,x1,y1,x2,y2)
    %should down sample.
    n = size(img_stack,1);
    M_sum = zeros(size(img_stack(1))); 
    
    for i = 1:size(img_stack)
        img_n = preprocess_img(img_stack(i),format);
        img_d = img_n(y1:500:y2,x1:500:x2);
        M_sum = M_sum + img_d;
    end
    
    M = M_sum ./ n;
    %round to int
    M = round(M);
end

function sigma = compute_variance(img_stack, M,format,x1,y1,x2,y2)
    n = size(img_stack,1);
    V_sum = zeros(size(img_stack(1)));
    
    for i = 1:size(img_stack)
        img_n = preprocess_img(img_stack(i),format);
        img_d = img_n(y1:500:y2,x1:500:x2);
        V_sum = V_sum + (img_d - M).^2;
    end
    
    sigma = V_sum ./ (n-1);
end

%just return the average of sigma from each image.


%plot variance respect to difference value of means
%fit it to a straight line.