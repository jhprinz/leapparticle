
class ReactionOneBody {
  float probability;

  int type1;

  ReactionOneBody() {
  }

  void execute(World me, Particle p1) {
  }
}

class BlueToZeroReaction extends ReactionOneBody {
  BlueToZeroReaction() {
    probability = 0.001;
    type1 = PARTICLE_BLUE;
  }

  void execute(World world, Particle p1) {
    world.sub(p1);
  }
}

class GreenToRedReaction extends ReactionOneBody {
  GreenToRedReaction() {
    probability = 0.005;
    type1 = PARTICLE_GREEN;
  }

  void execute(World world, Particle p1) {
    world.add((Particle) new RedParticle(p1.location));
    world.sub(p1);
  }
}

class CreateRedReaction extends ReactionOneBody {  
  CreateRedReaction() {
    probability = 0.02;
    type1 = PARTICLE_GENERATOR;
  }

  void execute(World world, Particle p1) {
    world.add((Particle) new RedParticle(p1.location));
  }
}

class CreateBlueReaction extends ReactionOneBody {  
  CreateBlueReaction() {
    probability = 0.1;
    type1 = PARTICLE_GENERATOR_BLUE;
  }

  void execute(World world, Particle p1) {
    world.add((Particle) new BlueParticle(p1.location));
  }
}

class YellowToBlueReaction extends ReactionOneBody {  
  YellowToBlueReaction() {
    probability = 0.004;
    type1 = PARTICLE_YELLOW;
  }

  void execute(World world, Particle p1) {
    world.add((Particle) new BlueParticle(p1.location));
    world.sub(p1);
  }
}

class BlueToYellowReaction extends ReactionOneBody {  
  BlueToYellowReaction() {
    probability = 0.001;
    type1 = PARTICLE_BLUE;
  }

  void execute(World world, Particle p1) {
    world.add((Particle) new YellowParticle(p1.location));
    world.sub(p1);
  }
}

class CreateGreenReaction extends ReactionOneBody {  
  CreateGreenReaction() {
    probability = 0.04;
    type1 = PARTICLE_GENERATOR_GREEN;
  }

  void execute(World world, Particle p1) {
    world.add((Particle) new GreenParticle(p1.location));
  }
}
