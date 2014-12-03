class Influence {
  int time;
  Boolean active;
  int duration;

  Influence() {
    active = false;
    time = 0;
    duration = 10;
  }

  void activate() {
    time = duration;
    active = true;
  } 

  void doAction() {
  }

  void run() {
    if (active) {
      // Do SOMETHING
      doAction();
      draw();
    }   
    if (time > 0) {
      time--;
      if (time == 0) {
        finish();
        active = false;
      }
    }
  }
  
  void finish() {
  }
  
  void draw() {
  }
}

class ShineLaserLight extends Influence {
  float probability = 0.05;

  ShineLaserLight() {
    super ();
    duration = 70;
  }
  void doAction() {
    if (time > 0) {
      for (Particle p : world.particles) { 
        if (p.type == PARTICLE_BLUE) {
          if (random(0.0, 1.0) < probability) {
            world.add((Particle) new YellowParticle(p.location));
            world.sub(p);
          }
        }
      }
    }
  }

  void draw() {
    fill(0, 255, 0, 50);
    strokeWeight(5);
    stroke(0);
    ellipse(height/2, height/2, 1100, 1100);
  }
}

class HeatPuls extends Influence {
  float targetTemperature;
  float normalTemperature;

  HeatPuls() {
    super ();
    duration = 150;
    targetTemperature = 50.0;
    normalTemperature = 1.0;
  }
  
  void doAction() {
//    world.globalTemperature = ((120 - time) * (targetTemperature - normalTemperature)) / 120.0 + normalTemperature; 
    world.globalTemperature = targetTemperature;
  }
  
  void finish() {
    world.globalTemperature = normalTemperature; 
  }

  void draw() {
    fill(255, 0, 0,  50);
    strokeWeight(5);
    stroke(0);
    ellipse(height/2, height/2, 1100, 1100);
  }
}

class TiltDish extends Influence {

  TiltDish() {
    super ();
    duration = 150;
  }
  
void doAction() {
    if (time > 0) {
      for (Particle p : world.particles) { 
         p.force.x += 1.5;
      }
    }
  }
  
  void draw() {
    fill(0, 0, 255,  50);
    strokeWeight(5);
    stroke(0);
    ellipse(height/2, height/2, 1100, 1100);
  }
}

