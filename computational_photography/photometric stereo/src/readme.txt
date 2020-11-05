This is a readme for assignment 5 Matlab files

Author : Ziwen Ye


main.m 
Main file to add path and load images to result in a 7xN matrix



uncalibrated.m
function B_e = uncalibrated(I,w,h)
The function takes in I which is Nx7 matrix which N represents number
Of pixels. W, h are size of input images.
B_e a pseudonormal matrix of Nx3 size


get_norm.m 
Function N_e = get_norm(B_e,w,h)
Given psuedonormal matrix Nx3, and w,h(width and height of an image), 
The function returns the normal of the image as form w x h x 3

get_albedo.m 
Function A_e = get_albedo(B_e,w,h)
Given psuedonormal matrix Nx3, and w,h(width and height of an image), 
The function returns the albedo of the image as form w x h x 3

Calibrated.m
function [B_c,N_c,A_c] = calibrated(I,L)
The function returns B_c, N_c, A_c given an input matrix I of Nx7 and a
Calibrated lighting matrix L, it returns psuedonormal matrix B_c
as well as normal and albedo of the image in shape of w x h x 3

integration.m
function B_q = integration(B_e,sigma,w,h,G)
Given an input pseudonormal_matrix, a sigma value for guassian filter
W,h dimension of the image, and a 3X3 GBR matrix, it returns a psuedonormal
Matrix B_q that guarantees integrability

norm_int.m
Function Z = norm_int(N_e)
Given the normal of the image, it returns a 3D reconstruction of the image

new_light.m
function L = new_light(B_e,l,w,h)
Given a psuedonormal matrix, a lighting direction, and w,h, the function
Returns a radiance L.


perspective.m
