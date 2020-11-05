
function [p1s,p2s,p3s,p4s] = calib_line(pvs , phs)
% make sure p1,p2,p3,p4 are in camear coordinate
    R_v = load('rc_v_banana.mat').Rc_h;
    R_h = load('rc_h_banana.mat').Rc_h;
    
    T_v = load('tc_v_banana.mat').Tc_h;
    T_h = load('tc_h_banana.mat').Tc_h;
    
    
    y1 = 300;
    y2 = 400;
    
    y3 = 900;
    y4 = 1000;

%     y1 = 10;
%     y2 = 100;
%     
%     y3 = 330;
%     y4 = 350;
    
    vns = []; 
    ps = [];
    
    p1s = [];
    p2s = [];
    p3s = [];
    p4s = [];
    
    for i = 1:size(pvs,1)
        
        pv = pvs(i,:);
        ph = phs(i,:);
        
        [p1,p2] = calib_shadow(ph, R_h, T_h,y3,y4);

        [p3,p4] = calib_shadow(pv, R_v, T_v,y1,y2);

        
        p1s = cat(1,p1s,p1');
        p2s = cat(1,p2s,p2');
        p3s = cat(1,p3s,p3');
        p4s = cat(1,p4s,p4');
        

    end
    
%     scatter3(p1s(:,1),p1s(:,2),p1s(:,3));
%     hold on
%      scatter3(p2s(:,1),p2s(:,2),p2s(:,3));
%     hold on
%      scatter3(p3s(:,1),p3s(:,2),p3s(:,3));
%     hold on
%      scatter3(p4s(:,1),p4s(:,2),p4s(:,3));
%     hold on

    scatter3(p1s(:,2),p1s(:,1),p1s(:,3),'MarkerFaceColor',[1,0,0]);
    hold on
     scatter3(p2s(:,2),p2s(:,1),p2s(:,3),'MarkerFaceColor',[0,1,0]);
    hold on
     scatter3(p3s(:,2),p3s(:,1),p3s(:,3),'MarkerFaceColor',[0,0,1]);
    hold on
     scatter3(p4s(:,2),p4s(:,1),p4s(:,3));
    hold on
    plot3d(0,0,0);
    
    
end