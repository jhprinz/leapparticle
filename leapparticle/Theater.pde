static int SCENE_SLEEP = 1;
static int SCENE_INTRODUCTION = 2;
static int SCENE_SETUP = 3;
static int SCENE_RHODOPSIN_SIMULATION = 6;
static int SCENE_DIFFUSION_SIMULATION = 4;
static int SCENE_REACTION_SIMULATION = 5;

static int SCENE_OUT = 1;
static int SCENE_IN = 2;
static int SCENE_RUN = 0;

static int SCENE_NUMBER = 10;

class Theater {
  Scene[] scenes;

  float time;
  int sceneID;
  int newSceneID;
  int mode;
  long timeStamp;
  ArrayList<Trigger> triggers;

  Boolean pause;

  Theater() {
    scenes = new Scene[SCENE_NUMBER];
    add((Scene) new SleepScene());
    add((Scene) new IntroductionScene());
    add((Scene) new SimulationScene());
    add((Scene) new SetupScene());
    add((Scene) new DiffusionScene());
    add((Scene) new ReactionScene());
    triggers = new ArrayList<Trigger>();
    sceneID = SCENE_DIFFUSION_SIMULATION;
    sceneID = SCENE_SETUP;
    mode = SCENE_IN;
    pause = false;
    timeStamp = 0;
  }

  void add(Scene s) {
    scenes[s.id] = s;
  }

  void run() {
    timeStamp++;
    if (sceneID > 0) {
      for (Trigger trig : triggers) {
        if (trig.triggerTime == timeStamp) {
          trig.doAction();
        }
        if (trig.triggerTime < timeStamp) {
          //          triggers.remove(trig);
        }
      }
      Scene s = scenes[sceneID];
      if (mode == SCENE_RUN) {
        time = 0;
        s.draw();
      } 
      else if (mode == SCENE_IN) {
        if (s.inDuration > 0) {
          s.drawIn(time / s.inDuration);
        }
        if (time > s.inDuration) {
          time = 0;
          mode = SCENE_RUN;
          th.triggers = new ArrayList<Trigger>();          
          s.setup();
          panel.handState = -1;
          panel.numFingers = -1;
        }
      }
      else if (mode == SCENE_OUT) {
        s.drawOut(time / s.outDuration);
        if (time == 0) {
          s.destroy();
        }
        if (time > s.outDuration) {
          time = 0;
          if (newSceneID > 0) {
            sceneID = newSceneID;
            mode = SCENE_IN;
          }
        }
      }
    }
    time++;
  }

  void activateButton(int button) {
    Scene s = scenes[sceneID];
    s.fingerButtonCallBack(button);
  }

  void switchTo(int nSceneID) {
    mode = SCENE_OUT;
    newSceneID = nSceneID;
    time = 0;
  }

  void add(Trigger trig) {
    trig.triggerTime = timeStamp + trig.delayTime;
    triggers.add(trig);
  }

  void alert(String t1, String t2, String okay) {
  }

  void enterPause() {
  }

  void leavePause() {
  }
}

class Scene {
  int id;

  float inDuration;
  float outDuration;

  FingerButton[] fButtons;

  Scene() {
    inDuration = 0;
    outDuration = 0;
    fButtons = new FingerButton[10];
  }

  void setup() {
  }

  void draw() {
  }

  void destroy() {
  } 

  void drawIn(float level) {
  }

  void drawOut(float level) {
  }

  void fingerButtonCallBack(int button) {
  }

  void triggerCallBack(int id) {
  }

  void add(Trigger trig) {
    th.add(trig);
  }
}

class SleepScene extends Scene {
  SleepScene() {
    id = SCENE_SLEEP;
    inDuration = 0;
    outDuration = 30;
  } 

  void setup() {
    panel.setFingerButton(5, new FingerButton(5, width/2, height/2, "", 3.2, 50));
  }

  void destroy() {
    panel.removeFingerButton(5);
  }

  void fingerButtonCallBack(int button) {
    if (button == 5) {
      th.switchTo(SCENE_SETUP);
    }
  }

  void drawOut(float t) {
    pushMatrix();
    translate(width/2, height/2);
    if (t < 0.5) {
      scale(cos(radians(t * 2.0 * 360.0)) * 0.05 + 0.95);
    } 
    else {
      tint(255, 255 * (2.0 - 2 * t) );
    }
    image (imgFinger[4], - 246, - 246);
    popMatrix();
  }

  void draw() {
    pushMatrix();
    translate(width/2, height/2);
    fill(0);
    textAlign(CENTER, CENTER);
    textFont(fontA);
    text("UNLOCK", 0, 300);
    popMatrix();
  }
}

class IntroductionScene extends Scene {
  IntroductionScene() {
    id = SCENE_INTRODUCTION;
    inDuration = 0;
    outDuration = 0;
  } 

  void setup() {   
    logS1 = new LogScreen( 200, 200, width - 400, height - 560);

    logS1.add("WILLKOMMEN!");
    logS1.add("");
    logS1.add("ICH HABE ALLE SIMULATIONEN NACH IHREN SPEZIFIKATIONEN EINGERICHTET.");
    logS1.add("");
    logS1.add("", 100);
    logS1.add("FUER DIE STEUERUNG HABE ICH DIE HANDGESTEN ERKENNUNG AKTIVIERT.");
    logS1.add("MIT ALLEN 5 FINGERN KOENNEN SIE IMMER DAS HAUPTMENUE AUFRUFEN");
    logS1.add("WENN SIE MOECHTEN, KOENNEN WIR SOFORT BEGINNEN ...");
    logS1.active = true;

    //    panel.setFingerButton(2, new FingerButton(2, width - 370, height - 170, "SETUP", 1.0));
    panel.setFingerButton(2, new FingerButton(2, width - 170, height - 170, "WEITER", 1.0));
  }

  void destroy() {
    logS1.active = false;
    panel.removeFingerButton(5);
  }

  void fingerButtonCallBack(int button) {
    if (button == 2) {
      th.switchTo(SCENE_SETUP);
    }
  }

  void draw() {
    logS1.run();
  }
}

class SimulationScene extends Scene {
  SimulationScene() {
    id = SCENE_RHODOPSIN_SIMULATION;
    inDuration = 0;
    outDuration = 0;
  } 

  void setup() {    
    world = new RhodopsinSimulation();
    world.running = false;
    particlePlot = new NumberPlot(height/2 + 600, 750, width - (height/2 + 600) - 100, 200);
    panel.setFingerButton(2, new FingerButton(2, width - 570, height - 170, "LASER", 1.0));
    panel.setFingerButton(4, new FingerButton(4, width - 370, height - 170, "HEAT", 1.0));
    panel.setFingerButton(3, new FingerButton(3, width - 170, height - 170, "MENU", 1.0, 50));

    logS1 = new LogScreen( height/2 + 600, 100, width - (height/2 + 600) - 100, 200);
    logS1.add("Erstelle Teilchen ...");
    logS1.add("Definiere Interaktionen ...");
    logS1.add("Definiere Reaktionen ...");
    logS1.add("Starte Simulation...");
    logS1.active = true;
    add(new StartSimulationTrigger(140));
  }

  void destroy() {
    logS1.active = false;
    world = null;
  }

  void fingerButtonCallBack(int button) {
    if (button == 2) {
      laser.activate();
      logS1.add("Laser Puls aktiviert!");
    }
    if (button == 4) {
      heat.activate();
      logS1.add("Waerme Puls aktiviert!");
    }
    if (button == 3) {
      logS1.add("Beende simulation ...");
      th.switchTo(SCENE_SETUP);
    }
  }

  void triggerCallBack(int id) {
  }

  void draw() {
    //  plot2.update(world.particleCount[PARTICLE_GREEN] / 2.0);
    world.run();
    if (!th.pause) {
      logS1.run();
      particlePlot.run();
    }
  }


  void enterPause() {
    world.running = false;
  }

  void leavePause() {
    world.running = true;
  }
}

class DiffusionScene extends Scene {
  DiffusionScene() {
    id = SCENE_DIFFUSION_SIMULATION;
    inDuration = 0;
    outDuration = 0;
  } 

  void setup() {    
    world = new DiffusionSimulation();
    world.running = false;
    particlePlot = new NumberPlot(height/2 + 600, 750, width - (height/2 + 600) - 100, 200);
    panel.setFingerButton(2, new FingerButton(2, width - 570, height - 170, "KIPPEN", 1.0));
    panel.setFingerButton(4, new FingerButton(4, width - 370, height - 170, "HEIZEN", 1.0));
    panel.setFingerButton(3, new FingerButton(3, width - 170, height - 170, "MENU", 1.0, 50));

    logS1 = new LogScreen( height/2 + 600, 100, width - (height/2 + 600) - 100, 200);
    logS1.add("Erstelle Teilchen ...");
    logS1.add("Definiere Interaktionen ...");
    logS1.add("Starte Simulation...");
    logS1.active = true;
    add(new StartSimulationTrigger(100));
  }

  void destroy() {
    logS1.active = false;
    world = null;
  }

  void fingerButtonCallBack(int button) {
    if (button == 2) {
      tilt.activate();
      logS1.add("Simluation gekippt !");
    }
    if (button == 4) {
      heat.activate();
      logS1.add("Waerme Puls aktiviert!");
    }
    if (button == 3) {
      logS1.add("Beende simulation...");
      th.switchTo(SCENE_SETUP);
    }
  }

  void triggerCallBack(int id) {
  }

  void draw() {
    //  plot2.update(world.particleCount[PARTICLE_GREEN] / 2.0);
    world.run();
    if (!th.pause) {
      logS1.run();
      particlePlot.run();
    }
  }


  void enterPause() {
    world.running = false;
  }

  void leavePause() {
    world.running = true;
  }
}

class ReactionScene extends Scene {
  ReactionScene() {
    id = SCENE_REACTION_SIMULATION;
    inDuration = 0;
    outDuration = 0;
  } 

  void setup() {    
    world = new ReactionSimulation();
    world.running = false;
    particlePlot = new NumberPlot(height/2 + 600, 750, width - (height/2 + 600) - 100, 200);
    panel.setFingerButton(2, new FingerButton(2, width - 570, height - 170, "LASER", 1.0));
    panel.setFingerButton(4, new FingerButton(4, width - 370, height - 170, "HEIZEN", 1.0));
    panel.setFingerButton(3, new FingerButton(3, width - 170, height - 170, "MENU", 1.0, 50));

    logS1 = new LogScreen( height/2 + 600, 100, width - (height/2 + 600) - 100, 200);
    logS1.add("Erstelle Teilchen ...");
    logS1.add("Definiere Reaktionen ...");
    logS1.add("Starte Simulation...");
    logS1.active = true;
    add(new StartSimulationTrigger(100));
  }

  void destroy() {
    logS1.active = false;
    world = null;
  }

  void fingerButtonCallBack(int button) {
    if (button == 2) {
      laser.activate();
      logS1.add("Laser Puls aktiviert !");
    }
    if (button == 4) {
      heat.activate();
      logS1.add("Waerme Puls aktiviert!");
    }
    if (button == 3) {
      logS1.add("Beende Simulation...");
      th.switchTo(SCENE_SETUP);
    }
  }

  void triggerCallBack(int id) {
  }

  void draw() {
    //  plot2.update(world.particleCount[PARTICLE_GREEN] / 2.0);
    world.run();
    if (!th.pause) {
      logS1.run();
      particlePlot.run();
    }
  }
}


class SetupScene extends Scene {

  //  float y1 = 0.65 / 4.0, y2 = 1.55 / 4.0, y3 = 2.45 / 4.0, y4 = 3.35 / 4.0;
  float y1 = 1.0 / 4.0, y2 = 2.0 / 4.0, y3 = 2.45 / 4.0, y4 = 3.0 / 4.0;


  SetupScene() {
    id = SCENE_SETUP;
    inDuration = 0;
    outDuration = 0;
  } 

  void setup() {    
    panel.removeFingerButton(4);
    panel.handState = 0;
    panel.handStateChangeTimer = 10;
    world = new MiniSimulationDiffusion((int)(y1*height));
    world2 = new MiniSimulationReaction((int)(y2*height));
    world3 = new MiniSimulationGeneration((int)(y4*height));
  }

  void destroy() {
    panel.removeFingerButton(1);
    panel.removeFingerButton(2);
    panel.removeFingerButton(3);
//    panel.removeFingerButton(4);
    panel.removeFingerButton(5);
    world = null;
  }

  void fingerButtonCallBack(int button) {
    if (button == 1) {
      th.switchTo(SCENE_DIFFUSION_SIMULATION);
    }
    if (button == 2) {
      th.switchTo(SCENE_REACTION_SIMULATION);
    }
    if (button == 3) {
      th.switchTo(SCENE_RHODOPSIN_SIMULATION);
    }
    if (button == 5) {
      th.switchTo(SCENE_SLEEP);
    }
  }

  void draw() {
    world.run();
    world2.run();
    world3.run();
    panel.setFingerButton(1, new FingerButton(1, 370, (int)(y1*height), "", 1.5, 60));
    panel.setFingerButton(2, new FingerButton(2, 370, (int)(y2*height), "", 1.5, 60));
    panel.setFingerButton(3, new FingerButton(3, 370, (int)(y4*height), "", 1.5, 60));
    //    panel.setFingerButton(4, new FingerButton(4, 370, (int)(y3*height), "", 1.5));
    panel.setFingerButton(5, new FingerButton(5, width - 170, height - 170, "SLEEP", 1.0, 50));

    textFont(fontA);
    fill(0);
    textAlign(LEFT, CENTER);
    strokeWeight(2);

    headlinetext("DIFFUSIONS DYNAMIK", 600, y1);
    headlinetext("REAKTIONS KINETIK", 600, y2);
    //    headlinetext("PARTICLE GENERATRION", 600, y3);
    headlinetext("ZELLSIMULATION", 600, y4);

    textFont(fontB);

    subtext("Untersuche den Einfluss von Temperatur auf Teilchen in einer Computersimulation", 600, y1);
    subtext("Untersuche, wie Teilchen miteinander reagieren in einer Computersimulation", 600, y2);
    //    subtext("Kanaele koennen Teilchen in eine Simulation bringen oder diese aus einer Simulation entfernen.", 600, y3);
    subtext("", 600, y4);
  }

  void headlinetext(String t, int x, float p) {
    float yp = p * height;
    text(t, x, (int)(yp) - 50);
    float tw = textWidth(t);
    line(x - 10, (int)(yp) - 22, x + tw + 10, (int)(yp) - 22);
  }

  void subtext(String t, int x, float p) {
    float yp = p * height;
    text(t, x + 20, (int)(yp) + 10);
  }
}

class Trigger {
  long triggerTime;
  long delayTime;

  Trigger( long d ) {
    delayTime = d;
    triggerTime = -1;
  }

  void doAction() {
  }
}

class StartSimulationTrigger extends Trigger {
  StartSimulationTrigger(long d) {
    super (d);
  }
  void doAction() {
    world.running = true;
  }
}

