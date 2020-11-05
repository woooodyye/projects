function B_q = integration(B_e,sigma,w,h,G)
%     transform B_e to three channels
%     w= 431; h = 369;
    
    
    B_et = permute(B_e, [2 1]);
    B_et = reshape(B_et,w,h,3);
    
%     apply gaussaain filter 
    B_f = imgaussfilt(B_et, sigma);
    
    [Fx,Fy] = gradient(B_f);
    
    A = form_matrix(B_et, Fx,Fy);
    
    [~,~,V] = svds(A,6);
    x = V(:,end);
    delta = get_delta(x);
    
%     B_q = delta * B_e;
    B_q = (delta^(-1)) * B_e;
    
%     suggestion rotation matrix
    mu = 0;
    v = 0;
    lambda= -10;
%     G = [1, 0 , 0 ; 0 , 1 , 0; mu, v, lambda];
    
    B_q = (inv(G)).' * B_q;
end

function A = form_matrix(B_e, Fx,Fy)
    B_e = reshape(B_e,[],1,3);
    Fx = reshape(Fx,[],3);
    Fy = reshape(Fy,[],3);
    
   	be1 = B_e(:,1);
    be2 = B_e(:,2);
    be3 = B_e(:,3);
    
    dbx1 = Fx(:,1);
    dbx2 = Fx(:,2);
    dbx3 = Fx(:,3);
    dby1 = Fy(:,1);
    dby2 = Fy(:,2);
    dby3 = Fy(:,3);
    
    A1 = be1 .* dbx2 - be2 .* dbx1;
    A2 = be1 .* dbx3 - be3 .* dbx1;
    A3 = be2 .* dbx3 - be3 .* dbx2;
    A4 = -be1 .* dby2 + be2 .* dby1;
    A5 = -be1 .* dby3 + be3 .* dby1;
    A6 = -be2 .* dby3 + be3 .* dby2;
    A = [A1,A2,A3,A4,A5,A6];
end

function delta = get_delta(x)
    delta = [-x(3),x(6),1 ; x(2), -x(5),0 ; -x(1), x(4), 0 ];
end