

% crop the image
% select the part which I want to reconstruct.

function P = recons(frog_temp,vns, ps)

%     imshow(frog_temp);
%     
%     p = ginput(2);
%     
%     x1 = p(1,2);
%     y1 = p(1,1);
%     x2 = p(2,2);
%     y2 = p(1,2);
%     


%     x1 = 138;
%     x2 = 406;
%     y1 = 136;
%     y2 = 336;

    x1 = 632;
    x2 = 1248;
    y1 = 476;
    y2 = 950;
%     

%     x1 = 1;
%     x2 = 1900;
%     y1 = 1;
%     y2 = 1070;
    
    frog_temp = frog_temp(y1:y2,x1:x2);

    load(['./data/','own/calib','/Calib_Results'],...
           'fc','cc','kc','alpha_c');
    P = zeros(size(frog_temp,1),size(frog_temp,2),3);
    
    for i = 1:size(frog_temp,1)
        for j = 1:size(frog_temp,2)
     
            t = frog_temp(i,j);
            
            if t ==0 
                continue
            end
            
            St = vns(t,:);
            
            Pt = ps(t,:);
           
            
            R =  pixel2ray([x1+j, y1+i]', fc,cc,kc, alpha_c);
            
            
            i_t = dot(St,-Pt) / dot(St,-R);
            
            
            p_i = R * i_t;
            
            P(i,j,:) = p_i;
            
        end
    end
    
end


