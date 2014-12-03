static int PARTICLE_RED = 0;
static int PARTICLE_GREEN = 1;
static int PARTICLE_BLUE = 2;
static int PARTICLE_YELLOW = 3;
static int PARTICLE_GENERATOR = 4;
static int PARTICLE_REMOVER = 5;
static int PARTICLE_REMOVER_2 = 6;
static int PARTICLE_GENERATOR_GREEN = 7;
static int PARTICLE_GENERATOR_BLUE = 8;


class Particle {
  // All the usual stuff
  PVector location;
  PVector velocity;
  PVector force;
  float radius;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed
  
  boolean deleted;

    float friction;
  float diffusion;

  int type;
  float mass;
  color col;    

  Boolean doInteraction;

  // Constructor initialize all values
  Particle( PVector l) {
    location = l.get();
    doInteraction = true;
  }

  void addForce(PVector f) {
    force.add(f);
  }

  void addDiffusion(float factor) {
    PVector dir = new PVector(1, 0);
    dir.rotate(radians(random(0, 360)));
    dir.mult(diffusion * factor);
    force.add(dir);
  }

  // Main "run" function
  public void run() {
    update();
    render();
  }

  // Method to update location
  void update() {
    // Update velocity
    if (mass > 0) {
      velocity.mult(friction);
      velocity.add(PVector.div(force, mass));
      velocity.limit(maxspeed);
    }
    force.mult(0.0);
    // Limit speed
    location.add(velocity);
  }

  void render() {
    // Simpler boid is just a circle
    fill(col);
    strokeWeight(1);
    stroke(50);
    pushMatrix();
    translate(location.x, location.y);
    ellipse(0, 0, radius * 2.0, radius * 2.0);
    popMatrix();

    if (debug) {
      line(location.x, location.y, location.x + velocity.x * 20, location.y + velocity.y * 20);
    }
  }
}

class RedParticle extends Particle {
  RedParticle( PVector l) {
    super( l );
    mass = 1.0;
    radius = 12;
    maxspeed = 2.0;
    maxforce = 0.1;
    force = new PVector(0, 0);
    velocity = new PVector(0, 0);
    col = color(128, 0, 0);
    type = PARTICLE_RED;
    friction = 0.99;
    diffusion = 0.5;
  }
}

class GreenParticle extends Particle {
  GreenParticle( PVector l) {
    super( l );
    mass = 3.0;
    radius = 15;
    maxspeed = 10.0;
    maxforce = 0.1;
    force = new PVector(0, 0);
    velocity = new PVector(0, 0);
    col = color(0, 128, 0);
    type = PARTICLE_GREEN;
    friction = 0.9;
    diffusion = 0.1;
  }
}

class BlueParticle extends Particle {
  BlueParticle( PVector l) {
    super( l );
    mass = 0.5;
    radius = 25;
    maxspeed = 10.0;
    maxforce = 0.1;
    force = new PVector(0, 0);
    velocity = new PVector(0, 0);
    col = color(0, 0, 128);
    type = PARTICLE_BLUE;
    friction = 0.3;
    diffusion = 0.1;
  }
}

class YellowParticle extends Particle {
  YellowParticle( PVector l) {
    super( l );
    mass = 10.0;
    radius = 8;
    maxspeed = 4.0;
    maxforce = 0.05;
    force = new PVector(0, 0);
    velocity = new PVector(0, 0);
    col = color(255, 128, 0);
    type = PARTICLE_YELLOW;
    friction = 0.1;
    diffusion = 0.5;
    doInteraction = true;
  }
}

class Generator extends Particle {
  Generator( PVector l ) {
    this(l, PARTICLE_GENERATOR);
  }
  Generator( PVector l, int id) {
    super( l );
    mass = 0.0;
    radius = 20;
    maxspeed = 0.0;
    maxforce = 0.05;
    force = new PVector(0, 0);
    velocity = new PVector(0, 0);
    col = color(128, 0, 0);
    type = id;
    friction = 0.1;
    diffusion = 0.5;
  }
  void render() {
    // Simpler boid is just a circle
    noFill();
    strokeWeight(1);
    stroke(0);
    pushMatrix();
    translate(location.x, location.y);
    stroke(col);
    ellipse(0, 0, radius * 2.0, radius * 2.0);
    ellipse(0, 0, radius * 2.0 - 4, radius * 2.0 - 4);
    stroke(255);
    ellipse(0, 0, radius * 2.0 - 2, radius * 2.0 - 2);
    popMatrix();
    if (debug) {
      line(location.x, location.y, location.x + velocity.x * 20, location.y + velocity.y * 20);
    }
  }
}

class Remover extends Particle {
  Remover( PVector l ) {
    this(l, PARTICLE_REMOVER);
  }
  Remover( PVector l, int remover) {
    super( l );
    mass = 0.0;
    radius = 20;
    maxspeed = 4.0;
    maxforce = 0.05;
    force = new PVector(0, 0);
    velocity = new PVector(0, 0);
    col = color(0, 0, 0);
    type = remover;
    friction = 0.1;
    diffusion = 0.5;
  }
  void render() {
    // Simpler boid is just a circle
    noFill();
    strokeWeight(1);
    pushMatrix();
    translate(location.x, location.y);
    stroke(col);
    ellipse(0, 0, radius * 2.0, radius * 2.0);
    ellipse(0, 0, radius * 2.0 - 4, radius * 2.0 - 4);
    stroke(0);
    ellipse(0, 0, radius * 2.0 - 2, radius * 2.0 - 2);
    popMatrix();
    if (debug) {
      line(location.x, location.y, location.x + velocity.x * 20, location.y + velocity.y * 20);
    }
  }
}

