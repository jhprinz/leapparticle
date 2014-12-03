import com.leapmotion.leap.CircleGesture;
import com.leapmotion.leap.Gesture.State;
import com.leapmotion.leap.Gesture.Type;
import com.leapmotion.leap.Hand;
import com.leapmotion.leap.KeyTapGesture;
import com.leapmotion.leap.ScreenTapGesture;
import com.leapmotion.leap.SwipeGesture;
import com.onformative.leap.LeapMotionP5;
import com.leapmotion.leap.Finger;

boolean debug = false;

static int MODE_SLEEP = 99;
static int MODE_SIMULATION = 1;
static int MODE_GOTOINIT = 2;     // MAKE THE TRANSITION FROM SLEEP TO INITIALIZATION OF THE SIMULATION
static int MODE_SETUP = 0;
static int MODE_INIT = 3;

LeapPanel panel;
World world, world2, world3;
Plot plot1, plot2;
Influence laser, heat, tilt;
LogScreen logS1, logS2;
Plot particlePlot;

PImage[] imgFinger;
PFont fontA, fontB;
Theater th;

void setup() {
  size(1920, 1200);
  frameRate(30);
  smooth();

  imgFinger = new PImage[5];

  // Load Fonts
  fontA = loadFont("Meta-Normal-48.vlw");
  fontB = loadFont("Colaborate-Thin-24.vlw");

  // Load Images
  imgFinger[0] = loadImage("fingers.001.png");
  imgFinger[1] = loadImage("fingers.002.png");
  imgFinger[2] = loadImage("fingers.003.png");
  imgFinger[3] = loadImage("fingers.004.png");
  imgFinger[4] = loadImage("fingers.005.png");

  //  plot1 = new Plot(1100, 400, 400, 250);
  //  plot2 = new Plot(1100, 400, 400, 250);

  th = new Theater();
  panel = new LeapPanel(new LeapMotionP5(this));

  //  th.switchTo(SCENE_INTRODUCTION);
  //  th.switchTo(SCENE_SETUP);
  //  th.switchTo(SCENE_SIMULATION);
}

void draw() {
  background(255);
  panel.draw();
  th.run();
}

void keyPressed() {
  if (key == 'd') {
//    debug = !debug;
  }
  if (key == '1') {
    //    panel.switchHandState(1);
  }
  if (key == '2') {
    //    panel.switchHandState(2);
  }
  if (key == '3') {
    //    panel.switchHandState(3);
  }
  if (key == '9') {
    laser.activate();
  }
}

void mousePressed() {
  if (debug) {
    //    panel.click();
  }
}

