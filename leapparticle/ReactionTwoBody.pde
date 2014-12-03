
class ReactionTwoBody {
  float probability;
  float distance;

  int type1;
  int type2;

  ReactionTwoBody() {
  }

  void execute(World me, Particle p1, Particle p2) {
  }
}

class RedRedToGreenReaction extends ReactionTwoBody {
  RedRedToGreenReaction() {
    probability = 0.001;
    distance = 40;
    type1 = PARTICLE_RED;
    type2 = PARTICLE_RED;
  }

  void execute(World world, Particle p1, Particle p2) {
    world.sub(p1);
    world.sub(p2);
    PVector newPosition = PVector.add(p1.location, p2.location);
    newPosition.mult(0.5);
    world.add((Particle) new GreenParticle(newPosition));
  }
}

class RedYellowToGreenYellow extends ReactionTwoBody {
  RedYellowToGreenYellow() {
    probability = 1.0;
    distance = 20;
    type2 = PARTICLE_RED;
    type1 = PARTICLE_YELLOW;
  }

  void execute(World world, Particle p1, Particle p2) {
    if (p1.type == PARTICLE_RED) {
      world.add((Particle) new GreenParticle(p1.location.get()));
      world.sub(p1);
    } 
    else {
      world.add((Particle) new GreenParticle(p2.location.get()));
      world.sub(p2);
    }
  }
}

class GreenRedTo3RedReaction extends ReactionTwoBody {
  GreenRedTo3RedReaction() {
    probability = 0.01;
    distance = 40;
    type1 = PARTICLE_GREEN;
    type2 = PARTICLE_RED;
  }

  void execute(World world, Particle p1, Particle p2) {
    PVector newPosition;
    if (p1.type == PARTICLE_GREEN) {
      newPosition = p1.location;
      world.sub(p1);
    } 
    else {
      newPosition = p2.location;
      world.sub(p2);
    }
    PVector shift = new PVector(20, 0);
    world.add((Particle) new RedParticle(newPosition));
    //    world.add((Particle) new RedParticle(PVector.add(newPosition,shift)));
    //    world.add((Particle) new RedParticle(PVector.sub(newPosition,shift)));
  }
}

class DeleteRedReaction extends ReactionTwoBody {
  int deleteType;

  DeleteRedReaction(int remover, int type) {
    probability = 0.5;
    distance = 30;
    type1 = remover;
    type2 = type;
    deleteType = type;
  }

  DeleteRedReaction(int type) {
    this(PARTICLE_REMOVER, type);
  }

  void execute(World world, Particle p1, Particle p2) {
    PVector newPosition;
    if (p1.type == deleteType) {
      world.sub(p1);
    } 
    else {
      world.sub(p2);
    }
  }
}

