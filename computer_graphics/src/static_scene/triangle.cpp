#include "triangle.h"

#include "CMU462/CMU462.h"
#include "GL/glew.h"

namespace CMU462 {
namespace StaticScene {

Triangle::Triangle(const Mesh* mesh, vector<size_t>& v) : mesh(mesh), v(v) {}
Triangle::Triangle(const Mesh* mesh, size_t v1, size_t v2, size_t v3)
    : mesh(mesh), v1(v1), v2(v2), v3(v3) {}

BBox Triangle::get_bbox() const {
  Vector3D tri_min;
  Vector3D tri_max;

  tri_min.x = min(mesh->positions[v1].x, min (mesh->positions[v2].x,mesh->positions[v3].x));
  tri_min.y = min(mesh->positions[v1].y, min (mesh->positions[v2].y,mesh->positions[v3].y));
  tri_min.z = min(mesh->positions[v1].z, min (mesh->positions[v2].z,mesh->positions[v3].z));
  tri_max.x = max(mesh->positions[v1].x, max (mesh->positions[v2].x,mesh->positions[v3].x));
  tri_max.y = max(mesh->positions[v1].y, max (mesh->positions[v2].y,mesh->positions[v3].y));
  tri_max.z = max(mesh->positions[v1].z, max (mesh->positions[v2].z,mesh->positions[v3].z));
  return BBox(tri_min,tri_max);
}

Vector3D Triangle::calculateUVT(const Ray& r) const {
  Vector3D e1= mesh->positions[v2] -  mesh->positions[v1];
  Vector3D e2= mesh->positions[v3] -   mesh->positions[v1];
  Vector3D s = r.o - mesh->positions[v1];


  double det = 1.f / (double) (dot(cross(e1,r.d), e2));

  double a1 = -(dot (cross(s,e2), r.d) );
  double a2 =  dot( cross(e1, r.d ), s );
  double a3 = - dot( cross(s, e2 ) , e1 );

  Vector3D uvt = det * Vector3D(a1,a2,a3);
  return uvt;
}

bool inbound(Vector3D uvt){
    double u = uvt.x;
    double v = uvt.y;
    double w = 1 - u  - v;
    if( (u+v) < 0 || (u+v) > 1 )
        return false;
    if( (u+w) < 0 || (u+w) > 1 )
        return false;
    if( (v+w) < 0 || (v+w) > 1 )
        return false;
    return true;
}

bool Triangle::intersect(const Ray& r) const {
  Vector3D e1= mesh->positions[v2] -  mesh->positions[v1];
  Vector3D e2= mesh->positions[v3] -  mesh->positions[v1];
  Vector3D s = r.o - mesh->positions[v1];


  double a3 = - dot( cross(s, e2 ) , e1 );

  double det = 1.f / (double) (dot(cross(e1,r.d), e2));


  if (dot(cross(e1,r.d), e2) ==0 ){
    return false;
  }

//  if(a3 < 0)
//      return false;


  double a1 = -(dot (cross(s,e2), r.d) );
  double a2 =  dot( cross(e1, r.d ), s );

  Vector3D uvt = det * Vector3D(a1,a2,a3);

  if( inbound(uvt)){
    if( ( uvt.z >= r.min_t ) && (uvt.z <= r.max_t) ){

      r.max_t = uvt.z;
      return true;
    }
    return false;

  }
  return false;
}

bool Triangle::intersect(const Ray& r, Intersection* isect) const {
  if (intersect(r)) {

      Vector3D uvt = calculateUVT(r);
      isect->t = uvt.z;

      Vector3D normal= (1.f -uvt.x-uvt.y)* mesh->normals[v1] +  uvt.x * mesh->normals[v2] +  uvt.y * mesh->normals[v3];

      isect->n = normal;

      //needs to flip the normal if necessary;
      if( (dot(r.d,normal)) > 0){
          isect->n = -isect->n;
      }


      isect->primitive = this;
      isect->bsdf= mesh->get_bsdf();

      return true;

  }
  return false;

}

void Triangle::draw(const Color& c) const {
  glColor4f(c.r, c.g, c.b, c.a);
  glBegin(GL_TRIANGLES);
  glVertex3d(mesh->positions[v1].x, mesh->positions[v1].y,
             mesh->positions[v1].z);
  glVertex3d(mesh->positions[v2].x, mesh->positions[v2].y,
             mesh->positions[v2].z);
  glVertex3d(mesh->positions[v3].x, mesh->positions[v3].y,
             mesh->positions[v3].z);
  glEnd();
}

void Triangle::drawOutline(const Color& c) const {
  glColor4f(c.r, c.g, c.b, c.a);
  glBegin(GL_LINE_LOOP);
  glVertex3d(mesh->positions[v1].x, mesh->positions[v1].y,
             mesh->positions[v1].z);
  glVertex3d(mesh->positions[v2].x, mesh->positions[v2].y,
             mesh->positions[v2].z);
  glVertex3d(mesh->positions[v3].x, mesh->positions[v3].y,
             mesh->positions[v3].z);
  glEnd();
}

}  // namespace StaticScene
}  // namespace CMU462
