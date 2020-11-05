#include "sphere.h"

#include <cmath>

#include "../bsdf.h"
#include "../misc/sphere_drawing.h"

namespace CMU462 {
namespace StaticScene {



bool Sphere::test(const Ray& r, double& t1, double& t2) const {
  //a is always positve.;
  double a = dot(r.d,r.d);
  double b = 2.f * dot(r.d, r.o - o);
  double c = dot(r.o-o, r.o-o) - r2;

  double deter = b*b - 4.f *a*c;

  //since t has to be non-negative, in range of min max, initialize to -1;

  if (deter < 0){
      return false;
  }

  //t1 is less than t2;
  t1 = (-b - sqrt(deter)) / (2*a);
  t2 = (-b + sqrt(deter)) / (2*a);
  return true;

}

bool Sphere::intersect(const Ray& r) const {
  double t1, t2;

  if(test(r,t1,t2)){
    if(t1 > r.max_t)
      return false;

    //t1 less than zero, t2 is closer intersect.
    if(t1 < 0){
      if(t2>= r.min_t && t2 <= r.max_t){
        r.max_t = t2;
        return true;
      }
      return false;
    }
    else{
      r.max_t = t1;
      return true;
    }
  }
  return false;


}

bool Sphere::intersect(const Ray& r, Intersection* isect) const {

  if(intersect(r)){
    isect->t = r.max_t;
    isect->n = normal(r.o + r.max_t * r.d);
    isect->primitive = this;
    isect->bsdf = get_bsdf();
    return true;
  }

  return false;

}

void Sphere::draw(const Color& c) const { Misc::draw_sphere_opengl(o, r, c); }

void Sphere::drawOutline(const Color& c) const {
  // Misc::draw_sphere_opengl(o, r, c);
}

}  // namespace StaticScene
}  // namespace CMU462
