#include "sampler.h"

namespace CMU462 {

// Uniform Sampler2D Implementation //

Vector2D UniformGridSampler2D::get_sample() const {
  double x = (double) (std:: rand()) / RAND_MAX;
  double y = (double) (std:: rand()) / RAND_MAX;
  return Vector2D(x, y);

}

// Uniform Hemisphere Sampler3D Implementation //

Vector3D UniformHemisphereSampler3D::get_sample() const {
  double Xi1 = (double)(std::rand()) / RAND_MAX;
  double Xi2 = (double)(std::rand()) / RAND_MAX;

  double theta = acos(Xi1);
  double phi = 2.0 * PI * Xi2;

  double xs = sinf(theta) * cosf(phi);
  double ys = sinf(theta) * sinf(phi);
  double zs = cosf(theta);

  return Vector3D(xs, ys, zs);
}

Vector3D CosineWeightedHemisphereSampler3D::get_sample() const {
  float f;
  return get_sample(&f);
}

Vector3D CosineWeightedHemisphereSampler3D::get_sample(float *pdf) const {
  // You may implement this, but don't have to.

    double Xi1 = (double)(std::rand()) / RAND_MAX; // Latitude
    double Xi2 = (double)(std::rand()) / RAND_MAX; // Longtitude

    double theta = acos(sqrt(1.0-Xi1*Xi1));
    double phi = 2.0 * PI * Xi2;

    *pdf = cosf(theta) / PI;
    return Vector3D(sinf(theta)*cosf(phi), sinf(theta)*sinf(phi), cosf(theta));


}

}  // namespace CMU462
