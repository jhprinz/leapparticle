static int PARTICLE_TYPES = 10;


class World {
  ArrayList<Particle> pAdds;
  ArrayList<Particle> pSubs;
  ArrayList<Particle> particles;
  ArrayList<Boundary> boundaries;
  ArrayList<Influence> influences;
  Interaction[][] interactions;
  ReactionTwoBody[][] reactions2;
  ReactionOneBody[] reactions1;

  int[] particleCount;

  PVector pullingForcePosition;
  boolean pullingForceActive;
  float pullingForceStrength;
  float pullingForceRadius;

  PVector pushingForcePosition;
  boolean pushingForceActive;
  float pushingForceStrength;
  float pushingForceRadius;

  float globalReactionSpeed;
  float globalTemperature;

  Boolean running;

  World() {
    particles = new ArrayList<Particle>();
    pAdds = new ArrayList<Particle>();
    pSubs = new ArrayList<Particle>();
    boundaries = new ArrayList<Boundary>();
    influences = new ArrayList<Influence>();
    interactions = new Interaction[PARTICLE_TYPES][PARTICLE_TYPES];
    reactions2 = new ReactionTwoBody[PARTICLE_TYPES][PARTICLE_TYPES];
    reactions1 = new ReactionOneBody[PARTICLE_TYPES];
    particleCount = new int[PARTICLE_TYPES];
    pullingForceActive = false;
    pullingForcePosition = new PVector(0, 0);
    pullingForceStrength = 30;
    pullingForceRadius = 30;

    pushingForceActive = false;
    pushingForcePosition = new PVector(0, 0);
    pushingForceStrength = 30;
    pushingForceRadius = 30;

    globalReactionSpeed = 1.0;
    globalTemperature = 1.0;
    running = true;
  }

  void add(Particle p) {
    pAdds.add(p);
  }

  void sub(Particle p) {
    pSubs.add(p);
  }

  void add(Interaction i, int p1, int p2) {    
    interactions[p1][p2] = i;
    interactions[p2][p1] = i;
  }

  void add(ReactionTwoBody r) {    
    reactions2[r.type1][r.type2] = r;
    reactions2[r.type2][r.type1] = r;
  }

  void add(ReactionOneBody r) {    
    reactions1[r.type1] = r;
  }

  void add(Boundary b) {
    boundaries.add(b);
  }

  void add (Influence f) {
    influences.add(f);
  }


  void applyDiffusion() {
    PVector direction;
    Particle p1;
    for (int i1 = particles.size()-1; i1 >= 1; i1--) { 
      p1 = (Particle) particles.get(i1);
      p1.addDiffusion( globalTemperature );
    }
  }

  void updateWorld() {
    if (!pSubs.isEmpty()) {
      for (Particle p : pSubs) { 
        particles.remove(p);
      }
      pSubs.clear();
    }

    if (!pAdds.isEmpty()) {
      for (Particle p : pAdds) { 
        particles.add(p);
      }
      pAdds.clear();
    }
  }

  void run() {
    updateWorld();

    if (running) {
      applyInteractions();    
      applyDiffusion();
      applyBoundaries();
      updateParticles();
      runInfluences();
    }
    renderParticles();
    renderBoundaries();
  }

  void runInfluences() {
    for (Influence f : influences) { 
      f.run();
    }
  }

  void updateParticles() {
    for (int i = 0; i<PARTICLE_TYPES; i++) {
      particleCount[i] = 0;
    }
    for (Particle p : particles) { 
      p.update();
      particleCount[p.type]++;
    }
  }

  void renderParticles() {
    for (Particle p : particles) { 
      p.render();
    }
  }

  void renderBoundaries() {
    for (Boundary b : boundaries) { 
      b.render();
    }
  }

  void setPushingForce(PVector p, float r) {
    pushingForceRadius = r;
    pushingForcePosition = p;
    pushingForceActive = true;
  }

  void noPushing() {
    pushingForceActive = false;
  }

  void setPullingForce(PVector p, float r) {
    pullingForceRadius = r;
    pullingForcePosition = p;
    pullingForceActive = true;
  }

  void noPulling() {
    pullingForceActive = false;
  }

  void applyBoundaries() {
    for (Boundary b : boundaries) {
      for (Particle p : particles) { 
        b.applyBoundary(p);
      }
    }
  }

  void applyInteractions() {
    PVector direction;
    PVector force;
    float strength;
    float distance;
    Interaction ww;
    Particle p1, p2;
    ReactionTwoBody ch2;
    ReactionOneBody ch1;
    for (int i1 = particles.size()-1; i1 >= 0; i1--) { 
      p1 = (Particle) particles.get(i1);
      ch1 = reactions1[p1.type];
      if (ch1 != null) {
        if (random(0.0, 1.0) < ch1.probability * globalReactionSpeed) {
          ch1.execute(this, p1);
        }
      }
      if (pullingForceActive) {
        PVector pullingDir = PVector.sub(p1.location, pullingForcePosition);
        if (pullingDir.mag() < pullingForceRadius / 2.0) {
          pullingDir.mult(-10.0);
          p1.addForce(pullingDir);
        }
      }
      if (pushingForceActive) {
        PVector pushingDir = PVector.sub(p1.location, pushingForcePosition);
        if (pushingDir.mag() - p1.radius < pushingForceRadius) {
          float len = pushingDir.mag();
          float over = len - p1.radius - pushingForceRadius;
          pushingDir.normalize();
          pushingDir.mult(- over);
          p1.location.add(pushingDir);
          //          pushingDir.mult((pushingForceRadius + p1.radius - pushingDir.mag())* 0.5);
          //          p1.addForce(pushingDir);
        }
      }
      if (p1.doInteraction) {
        for (int i2 = i1-1; i2 >= 0; i2--) { 
          p2 = (Particle) particles.get(i2);

          direction = PVector.sub(p1.location, p2.location);

          distance = direction.mag(); 
          direction.normalize();
          ww = interactions[p1.type][p2.type];

          if (ww != null) {
            strength = ww.apply(distance, p1, p2);
            force = direction.get();
            force.mult(strength * 0.5);
            p2.addForce(force);
            p1.addForce(PVector.mult(force, -1));
          }

          ch2 = reactions2[p1.type][p2.type];
          if (ch2 != null) {
            if (distance < ch2.distance) {
              if (random(0.0, 1.0) < ch2.probability * globalReactionSpeed) {
                ch2.execute(this, p1, p2);
              }
            }
          }
        }
      }
    }
  }
}

