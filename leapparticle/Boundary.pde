static int BOUNDARY_CIRCLE = 1;
static int BOUNDARY_BOUNCE = 1;

class Boundary {
  // All the usual stuff
  PVector center;
  PVector direction;
  int type;
  int shape;
  float radius;
  color col;    

  // Constructor initialize all values
  Boundary() {
    center = new PVector(0, 0);
    direction = new PVector(1, 0);
    radius = 100.0;
    shape = BOUNDARY_CIRCLE;
    type = BOUNDARY_BOUNCE;
    col = color(0);
  }

  void applyBoundary(Particle p) {
  }

  void render() {
  }

  PVector rand() {
    return new PVector(0, 0);
  }
}

class CircleBoundary extends Boundary {
  PVector dir;
  PVector dirRadius;
  PVector hitLocation;
  PVector hitOrtho;

  CircleBoundary(PVector c, float r) {
    super();
    center = c.get();
    radius = r;
    dir = new PVector(0, 0);
    dirRadius  = new PVector(0, 0);
    hitLocation = new PVector(0, 0);
    hitOrtho = new PVector(0, 0);
  }

  void applyBoundary(Particle p) {    
    dir = p.location.get();
    dir.sub(center);
    //    dirRadius = dir.get();
    //    dirRadius.setMag(radius);
    float d = dir.mag();
    dir.normalize();

    if (d + p.radius + 3.0> radius) {
      float m = dir.dot(p.velocity);
      dir.mult(-1.0 * m);
      p.velocity.add(dir);
      p.velocity.mult(0.0);
      dir.mult(-1.0 * m);
      dir.normalize();

      m =  (radius - p.radius - 3.0) + (d - (radius - p.radius - 3.0))*0.0;
      dir.mult(m);      
      dir.add(center);
      p.location.set(dir);
    }
  }

  void render() {
    // Simpler boid is just a circle
    noFill();
    strokeWeight(5);
    stroke(col);
    ellipse(center.x, center.y, radius * 2.0, radius * 2.0);
  }

  PVector rand() {
    float r = radius - 40;
    PVector pos = new PVector(r, r);
    while (pos.mag () > r) {
      pos = new PVector(random(-r, r), random(-r, r));
    }
    pos.add(new PVector(center.x, center.y));
    return pos;
  }
}

