// E > 0 right side
// E == 0 on line
// E < 0 left side
float E(Vector v0, Vector v1, Vector P) { 
  return (P.x() - v0.x()) * (v1.y() - v0.y()) - (P.y() - v0.y()) * (v1.x() - v0.x()); 
}
boolean inside(Vector P) {
  float[] sides = {E(v1, v2, P), E(v2, v3, P), E(v3, v1, P)};
  // checks if all edge functions are either negative or positive.
  return (sides[0] >= 0 && sides[1] >= 0 && sides[2] >= 0) || (sides[0] <= 0 && sides[1] <= 0 && sides[2] <= 0);
}

float[] barycentric(Vector P) {
  // abs if Edge functions is Negative
  float l1 = abs(E(v2, v3, P)) / abs(E(v2, v3, v1));
  float l2 = abs(E(v3, v1, P)) / abs(E(v3, v1, v2));
  float l3 = abs(E(v1, v2, P)) / abs(E(v1, v2, v3));
  return new float[] {l1, l2, l3};
}
color aliasing(Vector P, float step, int depth) {
  if(depth == 0) {
    return barycentricColor(new Vector(P.x() + step/2,P.y() + step/2));
  }
  color colors[] = {aliasing(P,step/2,depth-1),
                    aliasing(new Vector(P.x(), P.y()+step/2),step/2,depth-1),
                    aliasing(new Vector(P.x()+step/2, P.y()),step/2,depth-1),
                    aliasing(new Vector(P.x()+step/2, P.y()+step/2),step/2,depth-1),
                    barycentricColor(new Vector(P.x() + step/2,P.y() + step/2))
                  };
    float r = 0, g = 0, b = 0;
    for (int i = 0; i <= 4; ++i) {
    r += red(colors[i]); 
    g += green(colors[i]); 
    b += blue(colors[i]);}
    return color(r/5.0,g/5.0,b/5.0);
}

color barycentricColor(Vector P) {
  float[] weights = barycentric(P);
  float r = 0, g = 0, b = 0;
  if(!inside(P)) {
    return color(0);
  }
  // interpolate each channel 
  for (int i = 0; i < 3; ++i) {
    r += weights[i] * red(colors[i]); 
    g += weights[i] * green(colors[i]); 
    b += weights[i] * blue(colors[i]);
  }
  return color(r, g, b);
}