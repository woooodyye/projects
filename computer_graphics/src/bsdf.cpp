#include "bsdf.h"

#include <algorithm>
#include <iostream>
#include <utility>


using std::min;
using std::max;
using std::swap;

namespace CMU462 {

void make_coord_space(Matrix3x3& o2w, const Vector3D& n) {
  Vector3D z = Vector3D(n.x, n.y, n.z);
  Vector3D h = z;
  if (fabs(h.x) <= fabs(h.y) && fabs(h.x) <= fabs(h.z))
    h.x = 1.0;
  else if (fabs(h.y) <= fabs(h.x) && fabs(h.y) <= fabs(h.z))
    h.y = 1.0;
  else
    h.z = 1.0;

  z.normalize();
  Vector3D y = cross(h, z);
  y.normalize();
  Vector3D x = cross(z, y);
  x.normalize();

  o2w[0] = x;
  o2w[1] = y;
  o2w[2] = z;
}

// Diffuse BSDF //

Spectrum DiffuseBSDF::f(const Vector3D& wo, const Vector3D& wi) {
  return albedo * (1.0 / PI);
}

Spectrum DiffuseBSDF::sample_f(const Vector3D& wo, Vector3D* wi, float* pdf) {


  *wi = this->sampler.get_sample(pdf);
  //;

  return f(wo, *wi);
}

// Mirror BSDF //

Spectrum MirrorBSDF::f(const Vector3D& wo, const Vector3D& wi) {
  return Spectrum();
}

Spectrum MirrorBSDF::sample_f(const Vector3D& wo, Vector3D* wi, float* pdf) {

  reflect(wo, wi);
  *pdf = 1.f;

  return reflectance * (1.f / fabs(wi->z));
}





// Glossy BSDF //

/*
Spectrum GlossyBSDF::f(const Vector3D& wo, const Vector3D& wi) {
  return Spectrum();
}

Spectrum GlossyBSDF::sample_f(const Vector3D& wo, Vector3D* wi, float* pdf) {
  *pdf = 1.0f;
  return reflect(wo, wi, reflectance);
}
*/

// Refraction BSDF //

Spectrum RefractionBSDF::f(const Vector3D& wo, const Vector3D& wi) {
  return Spectrum();
}

Spectrum RefractionBSDF::sample_f(const Vector3D& wo, Vector3D* wi,
                                  float* pdf) {
 *pdf = 1.f;

 if(!refract(wo,wi,ior)){
   return Spectrum();
 }
 else{
     return transmittance * (1.f / fabs(wi->z));
 }

}

// Glass BSDF //

Spectrum GlassBSDF::f(const Vector3D& wo, const Vector3D& wi) {
  return Spectrum();
}


Spectrum GlassBSDF::sample_f(const Vector3D& wo, Vector3D* wi, float* pdf) {


//inspired by https://cs184.eecs.berkeley.edu/sp19/article/27/assignment-3-2,-part-1-mirror-an

  // total intern reflection.
  if(!refract(wo,wi,ior)){
    reflect(wo,wi);
    *pdf =1.f;
    return reflectance * (1.f /fabs(wi->z));
  }

  //calculate the fresnel equation
  //decide whether to return relfectance or refraction based on a random float.

  float p = (float) (std::rand()) / (float) RAND_MAX;

  Vector3D n = Vector3D(0,0,1);

  double ni, nt;

  //determine whether the medium entering or exiting is vacuum.
  if(dot(wo,n) > 0){
    ni = 1.0;
    nt = ior;
  }
  else{
    ni = ior;
    nt = 1.0;
  }

  double cos_i = fabs(wi->z);
  double cos_t = fabs(wo.z);

//  double r_para =  ( ( nt * cos_i ) - ni * cos_t ) / (float) (nt * cos_i + ni * cos_t );
//
//  double r_perp =  ( ni * cos_i - nt * cos_t ) / (float)( ni * cos_i + nt * cos_t);
//
//
//  double F_r =  (double)0.5 *  (r_para *r_para + r_perp * r_perp );


  double r_0 = pow(( (ni - nt) / (ni + nt) ),2);
  double F_r = r_0 + (1.f - r_0) * pow(1.f - cos_t,5);


  if (p < F_r){
      //still refraction, don't have to call refract, just calculate transmittance.
      //std::cout << ior << std::endl;
      reflect(wo,wi);
      *pdf =  F_r;
      return reflectance * F_r * ( 1.f / fabs(wi->z) );


  }
  else{
      refract(wo,wi,ior);
      double ratio = pow(nt/ni, 2);
      *pdf = 1.f - F_r;
      //return Spectrum();
      return  (1.f - F_r) * transmittance * (ratio / fabs(wi->z));

  }

  //return Spectrum();
}

void BSDF::reflect(const Vector3D& wo, Vector3D* wi) {

  Vector3D n = Vector3D(0,0,1);

  //*wi =   2*(dot(wo,n)*n) - wo ;
    wi->x = -wo.x;
    wi->y = -wo.y;
    wi->z = wo.z;


}

bool BSDF::refract(const Vector3D& wo, Vector3D* wi, float ior) {

  // referenced by https://cs184.eecs.berkeley.edu/sp19/article/27/assignment-3-2,-part-1-mirror-an

  double ratio;

  //check if ray enters the surface. ni/ nt
  if (wo.z > 0){
    ratio = 1.f / ior;
  }
  else{
    ratio = ior;
  }

  double inner = 1.f - pow(ratio,2) * ( 1.f - pow(wo.z,2) );

  if(inner < 0){
      return false;
  }

  wi->x = - wo.x * ratio;
  wi->y = - wo.y * ratio;

  if(wo.z>0){
      wi->z = -sqrt(inner);
  }
  else{
      wi->z = sqrt(inner);
  }

  return true;
}

// Emission BSDF //

Spectrum EmissionBSDF::f(const Vector3D& wo, const Vector3D& wi) {
  return Spectrum();
}

Spectrum EmissionBSDF::sample_f(const Vector3D& wo, Vector3D* wi, float* pdf) {
  *wi = sampler.get_sample(pdf);
  return Spectrum();
}

}  // namespace CMU462
