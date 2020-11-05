

function [vns,ps] = calib_plane(pvs , phs)
% make sure p1,p2,p3,p4 are in camear coordinate
    
    R_v = load('rc_v_banana.mat').Rc_h;
    R_h = load('rc_h_banana.mat').Rc_h;
    
    T_v = load('tc_v_banana.mat').Tc_h;
    T_h = load('tc_h_banana.mat').Tc_h;
    
    
    y1 = 300;
    y2 = 400;
    
    y3 = 950;
    y4 = 1000;
%     

%     y1 = 10;
%     y2 = 100;
%     
%     y3 = 330;
%     y4 = 350;


    vns = []; 
    ps = [];
    
    for i = 1:size(pvs,1)
        
        pv = pvs(i,:);
        ph = phs(i,:);
        
        [p1,p2] = calib_shadow(ph, R_h, T_h,y3,y4);

        [p3,p4] = calib_shadow(pv, R_v, T_v,y1,y2);


           
        v_n = cross((p2-p1),(p4-p3));
        v_n = v_n / norm(v_n);
        
        vns = cat(1,vns,v_n');
        
        ps = cat(1,ps,p2');
        
    end
    
end