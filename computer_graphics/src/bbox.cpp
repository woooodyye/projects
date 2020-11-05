#include "bbox.h"

#include "GL/glew.h"

#include <algorithm>
#include <iostream>

namespace CMU462 {

bool BBox::intersect(const Ray &r, double &t0, double &t1) const {
  // TODO (PathTracer):
  // Implement ray - bounding box intersection test
  // If the ray intersected the bounding box within the range given by
  // t0, t1, update t0 and t1 with the new intersection times.
//
    double tminx = (min.x - r.o.x) / r.d.x ;
    double tminy = (min.y - r.o.y) / r.d.y;
    double tminz = (min.z - r.o.z) / r.d.z;

    double tmaxx = (max.x - r.o.x) / r.d.x;
    double tmaxy = (max.y - r.o.y) / r.d.y;
    double tmaxz = (max.z - r.o.z) / r.d.z;


    if(tmaxx < tminx) std::swap(tminx, tmaxx);
    if(tmaxy < tminy) std::swap(tminy, tmaxy);
    if(tmaxz < tminz) std::swap(tminz, tmaxz);


    if( (tminx > tmaxy) || (tminy > tmaxy) ){
        return false;
    }

    tminx = std::max(tminx, tminy);
    tmaxx = std::min(tmaxx, tmaxy);


    if((tminx > tmaxz) || (tminz) > tmaxx ){
        return false;
    }

    double tmin = std::max(tminx, tminz);
    double tmax = std::min(tmaxx, tmaxz );

    if(  tmin < r.max_t  &&  tmax > r.min_t ){
        t0 = tmin;
        t1 = tmax;

        //r.max_t = tmax;
        return true;
    }

    return false;

}

void BBox::draw(Color c) const {
  glColor4f(c.r, c.g, c.b, c.a);

  // top
  glBegin(GL_LINE_STRIP);
  glVertex3d(max.x, max.y, max.z);
  glVertex3d(max.x, max.y, min.z);
  glVertex3d(min.x, max.y, min.z);
  glVertex3d(min.x, max.y, max.z);
  glVertex3d(max.x, max.y, max.z);
  glEnd();

  // bottom
  glBegin(GL_LINE_STRIP);
  glVertex3d(min.x, min.y, min.z);
  glVertex3d(min.x, min.y, max.z);
  glVertex3d(max.x, min.y, max.z);
  glVertex3d(max.x, min.y, min.z);
  glVertex3d(min.x, min.y, min.z);
  glEnd();

  // side
  glBegin(GL_LINES);
  glVertex3d(max.x, max.y, max.z);
  glVertex3d(max.x, min.y, max.z);
  glVertex3d(max.x, max.y, min.z);
  glVertex3d(max.x, min.y, min.z);
  glVertex3d(min.x, max.y, min.z);
  glVertex3d(min.x, min.y, min.z);
  glVertex3d(min.x, max.y, max.z);
  glVertex3d(min.x, min.y, max.z);
  glEnd();
}

std::ostream &operator<<(std::ostream &os, const BBox &b) {
  return os << "BBOX(" << b.min << ", " << b.max << ")";
}

}  // namespace CMU462
