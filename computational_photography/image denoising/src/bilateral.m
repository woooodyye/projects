

%%implement bilateral filtering
%size shoud be even?
function img_f = bilateral(img,s,sigma_s,sigma_r)
    %need to create a new img,else the value get modified in the loop
    img = normalize(img);
    
    w = size(img,1);
    h = size(img,2);
    img_f = zeros(size(img));
    
    for i= 1:w
        for j = 1:h
            spatial = create_kernel(img,i,j,s,sigma_s, "spatial");
            intensity = create_kernel(img,i,j,s,sigma_r,"intensity");
            I =create_I(img,i,j,s);
            I_f = filter(I,intensity,spatial);
            img_f(i,j) = I_f;
        end
    end
end


function kernel = create_kernel(img,i,j,s,sigma,type)
    w = size(img,1);
    h = size(img,2);
    a_s = i - s;
    a_e = i + s;
    b_s = j - s;
    b_e = j + s;
    
    a_s = max(1,a_s);
    a_e = min(a_e,w);
    b_s = max(1,b_s);
    b_e = min(b_e,h);
    
    if type == "intensity"
        I = img(a_s:a_e, b_s:b_e);
        
        kernel = exp( - (I- img(i,j)).^2 /  (2 * sigma^2) );

    else

        x = (a_s:a_e)';
        y = (b_s:b_e);
        kernel = exp(-((x-i).^2 + (y-j).^2) /  (2 * sigma^2) );
    end
end


function I_f = filter(I,intensity,spatial)
    %change the irradiance value at a pixel by doing bilateral
    %filtering in the kernel
    %i guess for convenience, I will just have a kernel that has values
    a= spatial .* intensity;
    
    b = spatial .* intensity .* I;
    
    k_s = sum(reshape(a,[],1));
    I_sum =  sum(reshape(b,[],1));
    I_f = I_sum ./ k_s;
end

function I = create_I(img,i,j,s)
    w = size(img,1);
    h = size(img,2);
    a_s = i - s;
    a_e = i + s;
    b_s = j - s;
    b_e = j + s;
    a_s = max(1,a_s);
    a_e = min(a_e,w);
    b_s = max(1,b_s);
    b_e = min(b_e,h);
    I = img(a_s:a_e, b_s:b_e);
end
