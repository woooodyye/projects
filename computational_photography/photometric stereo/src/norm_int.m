function Z = norm_int(N_e)
%     N_e is of shape 431x369x3
    eps = 0.0001;
    
    nx = N_e(:,:,1);
    ny = N_e(:,:,2);
    nz = N_e(:,:,3);
    
    zx=-((nx+ny+nz)~=0).*nx./(nz+(abs(nz)<10^-4));
    zy=-((nx+ny+nz)~=0).*ny./(nz+(abs(nz)<10^-4));
    
    fx = -N_e(:,:,1) ./ (N_e(:,:,3) + eps);
    fy = -N_e(:,:,2) ./ (N_e(:,:,3) + eps);
    
    
%     fx = fx ./ vecnorm(N_e);
%     fy = fy ./ vecnorm(N_e);
    
    Z = integrate_frankot(zx,zy);
%     Z
%     max(Z(:))
%     min(Z(:))
%    mu = 0;
%     v = 0;
%     lambda= 1;
%     G = [1, 0 , 0 ; 0 , 1 , 0; mu, v, lambda];
    
%     Z = (inv(G)).' * Z;
    
    figure;
   s=surf(-Z);  % use the ?-? sign since our Z-axis points down
                % output s is a ?handle? for the surface plot
   % adjust axis
   axis image; axis off;
   % change surface properties using SET
   set(s,'facecolor',[.5 .5 .5],'edgecolor','none');
   % add a light to the axis for visual effect
   l=camlight;
   % enable mouse-guided rotation
   rotate3d on

end