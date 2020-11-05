This is an instruction on how to use my matlab code.


To load all the parameters and files, call main.m
It has preloaded locations for all the color patches measured by ginput
It also allows you to load weighting functions with predefined function handler. It 


All the weighting functions are with in the file weight.m


To call linearization of jpg files.
Call linearize(images, tk, lambada, w_func) which will give you a g matrix;
Where images is your image stack you loaded, tk is the exposure array corresponding to each image, lambada is smoothness factor, w_func is your weighting scheme.

To apply the g function to the non-linearized image, call applyg(image,g) which returns the linearized version of the image;


HDR
For hdr merging, call hdr(images, tk, w_func, format, method)
The function returns an HDR image from the exposure stack.
Images is the image stack
Tk is the exposure stack
w_func is the weighting function
Format is the format of the file.
Method is a string "linear" or "log"
The current setting is for rgb
To change for raw, in wtop and wbot, change the ratio to ./65535.


ColorCorrection 
To apply color correction, call colorcorrecct(img_hdr,coordinates);
img_hdr is the HDR image generated from the image stack
Coordinates is an array corresponding the coordinates of colorchecker from 1-24
It's preloaded in the main file, so it can be directly called.

Tonemapping
To apply tone mapping to an HDR image, call tonemapping(img_hdr, K, B, colorspace)
img_hdr refers to the HDR image,
K refers to the key
B refers to burn
Colorspace refers to "RGB" or "xyY";


NoiseCalibration
To apply noise calibration, call noisecalib.m
[M,sigma] = noisecalib(img_stack,format,x1,y1,x2,y2)
This returns M and sigma of selected points in the image array, every 200 pixels.
X1,y1,x2,y2 is the bound of the calibration map.


For other information,
Read the function comments within the Matlab files.

