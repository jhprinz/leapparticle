// List all simulation setups to clean up the code

class DiffusionSimulation extends World {

  DiffusionSimulation() {
    super();
    add((Interaction) new StandardInteraction(), PARTICLE_RED, PARTICLE_RED);
    add((Interaction) new StandardInteraction(), PARTICLE_RED, PARTICLE_GREEN);
    add((Interaction) new StandardInteraction(), PARTICLE_GREEN, PARTICLE_GREEN);
    add((Interaction) new StandardInteraction(), PARTICLE_RED, PARTICLE_BLUE);
    add((Interaction) new StandardInteraction(), PARTICLE_GREEN, PARTICLE_BLUE);
    add((Interaction) new StandardInteraction(), PARTICLE_BLUE, PARTICLE_BLUE);

    add((Interaction) new StandardInteraction(), PARTICLE_YELLOW, PARTICLE_YELLOW);
    add((Interaction) new StandardInteraction(), PARTICLE_YELLOW, PARTICLE_RED);
    add((Interaction) new StandardInteraction(), PARTICLE_YELLOW, PARTICLE_GREEN);
    add((Interaction) new StandardInteraction(), PARTICLE_YELLOW, PARTICLE_BLUE);

    Boundary edge = new CircleBoundary(new PVector(height/2, height/2), 550);

    add(edge);

    heat = new HeatPuls();
    add((Influence) heat);

    tilt = new TiltDish();
    add((Influence) tilt);

    //  add((ReactionTwoBody) new RedRedToGreenReaction());

    // ADD PARTICLES

    // Non-Interacting Particle need to be inserted first ?

    for (int i = 0; i < 0; i++) {
      add((Particle)new YellowParticle(edge.rand()));
    }
    for (int i = 0; i < 300; i++) {
      add((Particle)new RedParticle(edge.rand()));
    }
    for (int i = 0; i < 40; i++) {
      add((Particle)new BlueParticle(edge.rand()));
    }
    for (int i = 0; i < 100; i++) {
      add((Particle)new GreenParticle(edge.rand()));
    }
    globalTemperature = 5.0;
  }
}

class RhodopsinSimulation extends World {

  RhodopsinSimulation() {
    super();
    add((Interaction) new RepulsiveInteraction(), PARTICLE_RED, PARTICLE_RED);
    add((Interaction) new StandardInteraction(), PARTICLE_RED, PARTICLE_GREEN);
    add((Interaction) new StandardInteraction(), PARTICLE_GREEN, PARTICLE_GREEN);
    add((Interaction) new StandardInteraction(), PARTICLE_RED, PARTICLE_BLUE);
    add((Interaction) new StandardInteraction(), PARTICLE_GREEN, PARTICLE_BLUE);
    add((Interaction) new StandardInteraction(), PARTICLE_BLUE, PARTICLE_BLUE);

    add((Interaction) new StandardInteraction(), PARTICLE_YELLOW, PARTICLE_YELLOW);
    //    add((Interaction) new StandardInteraction(), PARTICLE_YELLOW, PARTICLE_RED);
    add((Interaction) new StandardInteraction(), PARTICLE_YELLOW, PARTICLE_GREEN);
    add((Interaction) new StandardInteraction(), PARTICLE_YELLOW, PARTICLE_BLUE);

    Boundary edge = new CircleBoundary(new PVector(height/2, height/2), 550);

    add(edge);

    laser = new ShineLaserLight();
    add((Influence) laser);

    heat = new HeatPuls();
    add((Influence) heat);

    //  add((ReactionTwoBody) new RedRedToGreenReaction());
    add((ReactionTwoBody) new GreenRedTo3RedReaction());

    add((ReactionOneBody) new BlueToZeroReaction());
    add((ReactionOneBody) new GreenToRedReaction());

    add((ReactionOneBody) new CreateRedReaction());
    add((ReactionTwoBody) new DeleteRedReaction(PARTICLE_REMOVER, PARTICLE_GREEN));
    add((ReactionTwoBody) new DeleteRedReaction(PARTICLE_REMOVER_2, PARTICLE_RED));

    add((ReactionOneBody) new BlueToZeroReaction());
    add((ReactionOneBody) new GreenToRedReaction());
    add((ReactionOneBody) new YellowToBlueReaction());
    add((ReactionOneBody) new BlueToYellowReaction());
    add((ReactionOneBody) new GreenToRedReaction());

    add((ReactionTwoBody) new RedYellowToGreenYellow());

    for (int i = 0; i < 4; i++) {
      add((Particle)new Generator(edge.rand()));
    }
    Particle remover;

    for (int i = 0; i < 20; i++) {
      remover = new Remover(edge.rand());
      remover.col = color(0, 128, 0);
      add(remover);
    }

    for (int i = 0; i < 4; i++) {
      remover = new Remover(edge.rand(), PARTICLE_REMOVER_2);
      remover.col = color(128, 0, 0);
      add(remover);
    }

    // ADD PARTICLES

    // Non-Interacting Particle need to be inserted first ?

    for (int i = 0; i < 50; i++) {
      add((Particle)new BlueParticle(edge.rand()));
    }
    for (int i = 0; i < 300; i++) {
      add((Particle)new RedParticle(edge.rand()));
    }
    for (int i = 0; i < 0; i++) {
      add((Particle)new GreenParticle(edge.rand()));
    }
  }
}

class ReactionSimulation extends World {

  ReactionSimulation() {
    super();
    add((Interaction) new RepulsiveInteraction(), PARTICLE_RED, PARTICLE_RED);
    add((Interaction) new StandardInteraction(), PARTICLE_RED, PARTICLE_GREEN);
    add((Interaction) new StandardInteraction(), PARTICLE_GREEN, PARTICLE_GREEN);
    add((Interaction) new StandardInteraction(), PARTICLE_RED, PARTICLE_BLUE);
    add((Interaction) new StandardInteraction(), PARTICLE_GREEN, PARTICLE_BLUE);
    add((Interaction) new StandardInteraction(), PARTICLE_BLUE, PARTICLE_BLUE);

    add((Interaction) new StandardInteraction(), PARTICLE_YELLOW, PARTICLE_YELLOW);
    //    add((Interaction) new StandardInteraction(), PARTICLE_YELLOW, PARTICLE_RED);
    add((Interaction) new StandardInteraction(), PARTICLE_YELLOW, PARTICLE_GREEN);
    add((Interaction) new StandardInteraction(), PARTICLE_YELLOW, PARTICLE_BLUE);

    Boundary edge = new CircleBoundary(new PVector(height/2, height/2), 550);

    add(edge);

    laser = new ShineLaserLight();
    add((Influence) laser);

    heat = new HeatPuls();
    add((Influence) heat);

    //  add((ReactionTwoBody) new RedRedToGreenReaction());
    //    add((ReactionTwoBody) new GreenRedTo3RedReaction());

    add((ReactionOneBody) new BlueToZeroReaction());
    add((ReactionOneBody) new GreenToRedReaction());
    add((ReactionOneBody) new YellowToBlueReaction());
    add((ReactionOneBody) new BlueToYellowReaction());
    add((ReactionOneBody) new GreenToRedReaction());

    add((ReactionTwoBody) new RedYellowToGreenYellow());


    //    add((ReactionOneBody) new CreateRedReaction());
    //    add((ReactionTwoBody) new DeleteRedReaction(PARTICLE_REMOVER, PARTICLE_GREEN));
    //    add((ReactionTwoBody) new DeleteRedReaction(PARTICLE_REMOVER_2, PARTICLE_RED));

    //    add((Particle)new Generator(new PVector(900, 500)));

    //    Particle remover1 = new Remover(new PVector(700, 500));
    //    Particle remover2 = new Remover(new PVector(800, 500), PARTICLE_REMOVER_2);
    //    remover2.col = color(128, 0, 0);
    //    remover1.col = color(0, 128, 0);

    //    add(remover1);
    //    add(remover2);

    // ADD PARTICLES

    // Non-Interacting Particle need to be inserted first ?

    for (int i = 0; i < 60; i++) {
      add((Particle)new YellowParticle(edge.rand()));
    }
    for (int i = 0; i < 250; i++) {
      add((Particle)new RedParticle(edge.rand()));
    }
    for (int i = 0; i < 100; i++) {
      add((Particle)new GreenParticle(edge.rand()));
    }
    globalTemperature = 2.0;
  }
}

class MiniSimulationGeneration extends World {
  MiniSimulationGeneration(int yp) {
    super();
    add((Interaction) new StandardInteraction(), PARTICLE_BLUE, PARTICLE_BLUE);
    add((Interaction) new StandardInteraction(), PARTICLE_RED, PARTICLE_GREEN);
    add((Interaction) new StandardInteraction(), PARTICLE_GREEN, PARTICLE_GREEN);
    add((Interaction) new StandardInteraction(), PARTICLE_YELLOW, PARTICLE_YELLOW);
    add((Interaction) new StandardInteraction(), PARTICLE_YELLOW, PARTICLE_RED);
    add((Interaction) new StandardInteraction(), PARTICLE_YELLOW, PARTICLE_GREEN);

    Boundary edge = new CircleBoundary(new PVector(370, yp), 112);
    add(edge);

    add((Particle)new Generator(new PVector(455, yp), PARTICLE_GENERATOR_GREEN));
    add((Particle)new Generator(new PVector(285, yp), PARTICLE_GENERATOR_GREEN));
    add((ReactionOneBody) new CreateGreenReaction());
    add((ReactionTwoBody) new DeleteRedReaction(PARTICLE_REMOVER_2, PARTICLE_GREEN));

    Particle remover2 = new Remover(new PVector(370, yp - 85), PARTICLE_REMOVER_2);
    remover2.col = color(0, 128, 0);
    add(remover2);


    // Non-Interacting Particle need to be inserted first ?

    for (int i = 0; i < 3; i++) {
      add((Particle)new GreenParticle(edge.rand()));
    }
    for (int i = 0; i < 4; i++) {
      //      add((Particle)new RedParticle(edge.rand()));
    }
    for (int i = 0; i < 2; i++) {
      //      add((Particle)new GreenParticle(edge.rand()));
    }
  }
}

class MiniSimulationDiffusion extends World {

  MiniSimulationDiffusion(int yp) {
    super();
    add((Interaction) new StandardInteraction(), PARTICLE_RED, PARTICLE_RED);
    add((Interaction) new StandardInteraction(), PARTICLE_RED, PARTICLE_GREEN);
    add((Interaction) new StandardInteraction(), PARTICLE_GREEN, PARTICLE_GREEN);    

    Boundary edge = new CircleBoundary(new PVector(370, yp), 112);

    add(edge);

    // Non-Interacting Particle need to be inserted first ?

    for (int i = 0; i < 20; i++) {
      add((Particle)new RedParticle(edge.rand()));
    }
    for (int i = 0; i < 4; i++) {
      add((Particle)new GreenParticle(edge.rand()));
    }
  }
}

class MiniSimulationReaction extends World {
  MiniSimulationReaction(int yp) {
    super();
    add((Interaction) new StandardInteraction(), PARTICLE_RED, PARTICLE_RED);
    add((Interaction) new StandardInteraction(), PARTICLE_RED, PARTICLE_GREEN);
    add((Interaction) new StandardInteraction(), PARTICLE_GREEN, PARTICLE_GREEN);
    add((Interaction) new StandardInteraction(), PARTICLE_YELLOW, PARTICLE_GREEN);
    add((ReactionOneBody) new GreenToRedReaction());   
    add((ReactionTwoBody) new RedYellowToGreenYellow());

    Boundary edge = new CircleBoundary(new PVector(370, yp), 112);

    add(edge);

    // Non-Interacting Particle need to be inserted first ?

    for (int i = 0; i < 8; i++) {
      add((Particle)new RedParticle(edge.rand()));
    }
    for (int i = 0; i < 1; i++) {
      add((Particle)new GreenParticle(edge.rand()));
    }

    add((Particle)new YellowParticle(edge.center));

    globalTemperature = 1;
  }
}

