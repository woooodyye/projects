#include "environment_light.h"
#include <iostream>

namespace CMU462 {
    namespace StaticScene {

EnvironmentLight::EnvironmentLight(const HDRImageBuffer* envMap)
        : envMap(envMap) {

    //referenced from https://cs184.eecs.berkeley.edu/sp19/article/29/assignment-3-2,-part-3-environme
    w = envMap->w;
    h = envMap->h;

    //discreteP is p(phi,theta);

    //initialize all vectors
    discreteP.resize( w*h);
    p_theta.resize(h);
    p_cond.resize( w* h);
    cdf_theta.resize(h);
    cdf_cond.resize(w*h);

    //

    double sum =0;
    //summing all the fluxes in each pixel and then normalize.
    for(size_t i = 0; i< w; i++){
        for(size_t j = 0; j < h; j++){
            double theta = PI * (j / (float) h);
            double flux = envMap->data[j*w + i].illum() * sin(theta);
            sum += flux;
            discreteP[ j* w + i] = flux;
        }
    }

    //normalize flux of each pixel thus that total pixels sum to 1;
    for(size_t i =0; i< discreteP.size(); i++){
        discreteP[i] = discreteP[i] / sum;
    }


    //assign marginal distribution.
    for(size_t j=0; j< h; j++){
        for(size_t i =0; i< w; i++){
            p_theta[j] += discreteP[j*w + i];
        }
    }

    //assign conditional distribution.
    for(size_t j=0; j< h; j++){
        for(size_t i =0; i< w; i++){
            p_cond[ j*w + i] = discreteP[j * w + i]  / p_theta[j];
        }
    }

    //create cumulative cdf maps.
    double ptheta, pthetaphi;

    for(size_t j=0; j<h; j++){
        pthetaphi = 0;
        for(size_t i = 0; i< w; i++){
            pthetaphi  += p_cond[j*w+i];
            cdf_cond[j*w+i] = pthetaphi;
        }
        ptheta += p_theta[j];
        cdf_theta[j] = ptheta;
    }
}



Vector3D getUniformSample(){
    // math equation referenced from https://www.et.byu.edu/~vps/ME340/TABLES/12.0.pdf

    double Xi1 = (double)(std::rand()) / RAND_MAX; // Latitude
    double Xi2 = (double)(std::rand()) / RAND_MAX; // Longtitude

    double theta = acos(sqrt(1.0-Xi1*Xi1));
    double phi = 2.0 * PI * Xi2;

    //needs to rotate it to fir the reference solution.
    return Vector3D(sinf(theta)*sinf(phi), cosf(theta), sinf(theta)*cosf(phi));

}

bool compare(double x, double y){
    return x<y;
}

void EnvironmentLight::importanceSample(float *pdf, Vector3D* wi) const{
    double x = (double)(std::rand()) / RAND_MAX;
    double y = (double)(std::rand()) / RAND_MAX;

    //use binary search to select marginal probability.
    double i, j;

    for(j = 0; j< cdf_theta.size(); j++){
        if( y< cdf_theta[j] ){
            break;
        }
    }


    for(i = 0; i< w; i++){
        if( x < cdf_cond[i+ j*w]){
            break;
        }
    }


    //double xi = (i - j*w) / w;
    double xi = i /w;
    double yi = j / h;

    double theta = acos(sqrt(1.0-xi*xi));
    double phi = 2.0 * PI * yi;

    //needs to rotate it to fir the reference solution.
    *wi =Vector3D(sinf(theta)*sinf(phi), cosf(theta), sinf(theta)*cosf(phi));
    double ratio = w*h / (2* pow(PI,2) * sin(theta));
    *pdf = discreteP[i + j*w] * ratio;

}

Spectrum EnvironmentLight::sample_L(const Vector3D& p, Vector3D* wi,
                                    float* distToLight, float* pdf) const {

//    *pdf = 1.f/4.f * PI;
//    *wi = getUniformSample();

    importanceSample(pdf,wi);
    Ray r= Ray(p,*wi);
    *distToLight = INF_D;

    return sample_dir(r);
}

Spectrum EnvironmentLight::sample_dir(const Ray& r) const {
    //convert x,y,z coordinate to theta, phi.

    //acos returns value in [0, PI].
    double theta = acos(r.d.y);

   //adjust the phi to [0,2*PI] coordinates.
   double phi = atan2( r.d.x , -r.d.z ) + PI;


    //need to normalize in regard to [0,1] coordinate space in phi, theta.
    double u = phi / (2.f * PI);
    double v = theta / PI;



    //adjust to the image size.
    double px = u * w;
    double py = v * h;

    double pxa = floor(px);
    double pxb = ceil(px);
    double pya = floor(py);
    double pyb = ceil(py);

    double a = px-pxa;
    double b = py-pya;

    //need to wrap around on edge cases. else may segfault.
    if(pxb >= w){
        pxb=0;
    }
    if(pyb >= h){
        pyb =0;
    }
//
    //no longer need to do bilinear sampling for importance sampling.
    //return envMap->data[(int)pxb + w*(int)pyb];

    //perform a bilinear filter.
    Spectrum t1 = (1.f -a ) * (1.f - b) * envMap->data[(int)pxa + w* int(pya)];
    Spectrum t2 = a* (1.f -b) * envMap->data[(int)pxb + w* int(pya)];
    Spectrum t3 = (1.f -a ) * b * envMap->data[(int)pxa + w* int(pyb)];
    Spectrum t4 = a* b * envMap->data[(int)pxb + w* int(pyb)];

    return (t1 + t2 + t3 + t4);

}

    }  // namespace StaticScene
}  // namespace CMU462
