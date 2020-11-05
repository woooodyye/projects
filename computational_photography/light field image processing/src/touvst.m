%img is 2d.
function img_4d = touvst(img,u,v,s,t)
    a1 = im2col(img,[u,v],'distinct');
    a2 = reshape(a1,t,s,[]);
    a3 = reshape(a2,u,v,[]);
    a4 = reshape(a3,u,v,s,t);
    a5 =permute(a4,[1,2,4,3]);
    img_4d = a5;
end