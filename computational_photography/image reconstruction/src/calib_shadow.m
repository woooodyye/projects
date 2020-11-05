
function [f1,f2] = calib_shadow(p, R , T, y1,y2)

    load(['./data/','own/calib','/Calib_Results'],...
           'fc','cc','kc','alpha_c');

%     y1 and y2 are preset.

    [p1,p2] = interp_line(p, y1,y2);
    
    R1 =  pixel2ray([p1,y1]', fc,cc,kc, alpha_c);
%     this is in camera coordinate system.

% how to do an intersection in the consistent coordinate frame
    
    R2 = pixel2ray([p2,y2]', fc, cc, kc, alpha_c);
    
    
% backproject points on the plane coordinates to camera coordinates
    pp1 = [0;0;0];
    pp2 = [0;558.8;0];
    pp3 = [303.125;0;0];
    
    pc1 = R * pp1 + T;
    pc2 = R * pp2 + T;
    pc3 = R * pp3 + T;
    
    v1 = pc2 - pc1;
    v2 = pc3 - pc1;
    
    np = cross(v1,v2);
    
    t1 = dot(np,-pc1) / dot(np,-R1);
    
    t2 = dot(np,-pc1) / dot(np,-R2);
    
    f1 = R1 * t1;
    
    f2 = R2 * t2;
    
    
end

function [p1,p2] = interp_line(L,y1,y2)
    p1 = polyval(L,y1);
    p2 = polyval(L,y2);
end

