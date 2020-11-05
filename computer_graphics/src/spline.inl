// Given a time between 0 and 1, evaluates a cubic polynomial with
// the given endpoint and tangent values at the beginning (0) and
// end (1) of the interval.  Optionally, one can request a derivative
// of the spline (0=no derivative, 1=first derivative, 2=2nd derivative).
template <class T>
inline T Spline<T>::cubicSplineUnitInterval(
    const T& position0, const T& position1, const T& tangent0,
    const T& tangent1, double normalizedTime, int derivative) {

  double time = normalizedTime;
  double timesqr = time * time;
  double timecub = timesqr * time;

  double h00 = 2*timecub - 3*timesqr + 1;
  double h10 = timecub - 2* timesqr + time;
  double h01 = -2*timecub + 3*timesqr;
  double h11 = timecub - timesqr;

  //take derivative to the bases.
  if(derivative== 1){
    h00 = 6 * timesqr - 6 * time;
    h10 = 3 * timesqr - 4 * time + 1;
    h01 = -6 * timesqr  + 6 * time;
    h11 = 3 * timesqr - 2* time;
  }
  if(derivative == 2){
    h00 = 12 * time - 6;
    h10 = 6 * time - 4;
    h01 = -12 * time + 6;
    h11 = 6 * time - 2;
  }

  // P _t is a type T;
  T P_t = h00* position0 + h10* tangent0 + h01 * position1 + h11 * tangent1;

  return P_t;

}

// Returns a state interpolated between the values directly before and after the
// given time.
template <class T>
inline T Spline<T>::evaluate(double time, int derivative) {


  //empty maps have no knots;
  if(knots.size()<1){
    return T();
  }

  //only one knots
  if(knots.size()==1){
      //if zero derivative, return constant value, else return zero.
      if(derivative == 0)
        return knots.begin()->second;
      else
        return T();
  }

  //to the left of the initial knots.
  //may need to modify if they are derivatives.
  if(time <= knots.begin()->first){
      if(derivative ==0)
          return knots.begin()->second;
      else
          return T();
  }

  //to the right of final knots
  if(time >= prev(knots.end())->first){
      if(derivative == 0)
          return prev(knots.end())->second;
      else
          return T();
  }


  //at least two knots.
  KnotIter t2_iter = knots.upper_bound(time);
  KnotIter t1_iter ,t3_iter , t0_iter;

  T  p0, p1, p2 , p3;

  double t0, t1, t2, t3;

  t1_iter = t2_iter;
  t1_iter--;

  t1 = t1_iter->first; t2 = t2_iter->first;
  p1 = t1_iter->second; p2 = t2_iter->second;


  double dt = t2 - t1;

  // no node two to the right. //end is a dummy node.
  if(t2_iter == prev(knots.end()) ){
    //create a virtue node
    t3 = t2 + (t2 - t1); p3 = p2 + (p2 - p1);
  }
  else{
      //use the nodes two to the right.
    t3_iter = t2_iter++ ; t3 = t3_iter->first; p3 = t3_iter->second;
  }


  // no node two to the left;
  if(t1_iter == knots.begin()){
    t0 = t1 - (t2 - t1); p0 = p1 - (p2 - p1);
  }
  else{
    t0_iter = t1_iter--; t0 = t0_iter->first; p0 = t0_iter->second;
  }


  T m1 , m2;

  //normalize the tangent to [0, 1 ]
  m1 = (p2 - p0) * dt / ( (t2 - t0));
  m2 = (p3 - p1 ) * dt / ( (t3 - t1) );


  //normalize time to [0, 1] interval;
  double timeNorm = ( time - t1 ) / dt;

  return cubicSplineUnitInterval(p1, p2, m1, m2, timeNorm, derivative);

}




// Removes the knot closest to the given time,
//    within the given tolerance..
// returns true iff a knot was removed.
template <class T>
inline bool Spline<T>::removeKnot(double time, double tolerance) {
  // Empty maps have no knots.
  if (knots.size() < 1) {
    return false;
  }

  // Look up the first element > or = to time.
  typename std::map<double, T>::iterator t2_iter = knots.lower_bound(time);
  typename std::map<double, T>::iterator t1_iter;
  t1_iter = t2_iter;
  t1_iter--;

  if (t2_iter == knots.end()) {
    t2_iter = t1_iter;
  }

  // Handle tolerance bounds,
  // because we are working with floating point numbers.
  double t1 = (*t1_iter).first;
  double t2 = (*t2_iter).first;

  double d1 = fabs(t1 - time);
  double d2 = fabs(t2 - time);

  if (d1 < tolerance && d1 < d2) {
    knots.erase(t1_iter);
    return true;
  }

  if (d2 < tolerance && d2 < d1) {
    knots.erase(t2_iter);
    return t2;
  }

  return false;
}

// Sets the value of the spline at a given time (i.e., knot),
// creating a new knot at this time if necessary.
template <class T>
inline void Spline<T>::setValue(double time, T value) {
  knots[time] = value;
}

template <class T>
inline T Spline<T>::operator()(double time) {
  return evaluate(time);
}
