

class Interaction {
  Interaction() {
  }

  float apply(float dist, Particle p1, Particle p2) {
    return 0.0;
  }
}

class MorseInteraction extends Interaction {
  MorseInteraction() {
    super();
  }

  float apply(float dist, Particle p1, Particle p2) {    
    return morsePotential(dist, p1.radius, p2.radius);
  }

  float morsePotential( float d, float r1, float r2) {
    float aC = 0.02;
    float dC = (r1+r2)*1.2;
    float fC = 20;
    float v = exp(- aC*(d - dC));
    float morseCutOff = 100;
    if (d < morseCutOff) {
      return -2.0*aC*fC*v*(v - 1.0);
    } 
    return 0.0;
  }
}

class StandardInteraction extends Interaction {
  StandardInteraction() {
    super();
  }

  float apply(float dist, Particle p1, Particle p2) {    
    return mixPotential(dist, p1.radius, p2.radius);
  }

  float mixPotential( float d, float r1, float r2) {
    float aC = 0.02;
    float dC = (r1+r2)*2.5;
    float fC = 20;
    float v = exp(- aC*(d - dC));
    float v2 = pow(dC/d, 6);
    float morseCutOff = 100;
    if (d < dC* 0.4) {
      return -2.0*aC*fC*v*(v - 1.0) * 10;
    } 
    if (d < morseCutOff) {
      return -2.0*aC*fC*v*(v - 1.0) - 0.0005 * v2 * v2;
    } 
    return 0.0;
  }
}

class LennardJonesInteraction extends Interaction {
  LennardJonesInteraction() {
    super();
  }

  float apply(float dist, Particle p1, Particle p2) {    
    return ljPotential(dist, p1.radius, p2.radius);
  }

  float ljPotential( float d, float r1, float r2) {
    float aC = 0.0005;
    float dC = (r1+r2)*1.2;
    float fC = 20;
    float v2 = pow(dC/d, 6);
    float morseCutOff = 200;
    if (d < morseCutOff) {
      return - aC * ( v2 * v2 + 2 * v2);
    } 
    return 0.0;
  }
}

class RepulsiveInteraction extends Interaction {
  RepulsiveInteraction() {
    super();
  }

  float apply(float dist, Particle p1, Particle p2) {    
    return ljPotential(dist, p1.radius, p2.radius);
  }

  float ljPotential( float d, float r1, float r2) {
    float aC = 5.;
    float dC = (r1+r2)*1.2;
    float fC = 20;
    float v2 = pow(dC/d, 6);
    float morseCutOff = 150;
    if (d < morseCutOff) {
      if (r1+r2 < d) {
        return - aC * 1.0 / (d - r1 - r2);
      } 
      else {
        return - aC * 1.0;
      }
    } else {
      return 0.0;
    }
  }
}

