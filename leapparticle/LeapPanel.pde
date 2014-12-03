import com.leapmotion.leap.CircleGesture;
import com.leapmotion.leap.Gesture.State;
import com.leapmotion.leap.Gesture.Type;
import com.leapmotion.leap.Hand;
import com.leapmotion.leap.KeyTapGesture;
import com.leapmotion.leap.ScreenTapGesture;
import com.leapmotion.leap.SwipeGesture;
import com.onformative.leap.LeapMotionP5;
import com.leapmotion.leap.Finger;

static int HANDSTATE_NONE = 0;
static int HANDSTATE_ONE = 1;
static int HANDSTATE_TWO = 2;
static int HANDSTATE_THREE = 3;
static int HANDSTATE_FIVE = 5;

PVector fingerMID = new PVector(0, 0, 0);

LeapMotionP5 leap;

class LeapPanel {

  Hand myHand;

  ControlPanel cPanel;

  PVector palmPosition;

  int handState = HANDSTATE_NONE;
  int handStateChangeTimer;
  int middleFingerID;

  boolean transition;

  int numFingers;
  int nNumFingers;

  PVector[] fingers;
  PVector[] nFingers;

  FingerButton[] fButtons;

  LeapPanel(LeapMotionP5 myLeap) {
    // Setup the leapmotion library
    fingers = new PVector[15];
    nFingers = new PVector[15];

    handStateChangeTimer = 0;
    numFingers = 0;
    nNumFingers = 0;
    leap = myLeap;
    transition = false;

    cPanel = new ControlPanel(3, 100);

    leap.enableGesture(Type.TYPE_KEY_TAP);

    fButtons = new FingerButton[15];
    middleFingerID = 0;
  }

  void updateHand() {
    nNumFingers = 0;
    try {
      myHand = leap.getHand(0);    
      palmPosition = leap.vectorToPVector(myHand.palmPosition());
      for (Finger finger : leap.getFingerList()) {
        nFingers[nNumFingers] = leap.getTip(finger);
        nFingers[nNumFingers].x -= width/2 -400; 

        nNumFingers++;
      }
    }
    finally{
    }


    if (debug) {
      nNumFingers = handState;
      nFingers[0] = new PVector(mouseX, mouseY);
      nFingers[1] = new PVector(mouseX + 40, mouseY);
      nFingers[2] = new PVector(mouseX - 40, mouseY);
    }


    if (handState != nNumFingers) {
      if (numFingers != nNumFingers) {
        if (fButtons[nNumFingers] != null) {
          handStateChangeTimer = fButtons[nNumFingers].triggerTime;
        } 
        else {          
          handStateChangeTimer = 2;
        }
        numFingers = nNumFingers;
      }
      else {
        if (handStateChangeTimer > 0) {
          handStateChangeTimer--;
          if (fButtons[nNumFingers] != null) {
            if (handStateChangeTimer == fButtons[nNumFingers].triggerTime - 2) {
              switchHandState(numFingers);
              handState = -1;
            }
          }
          if (handStateChangeTimer == 0) {
            if (fButtons[nNumFingers] != null) {
              th.activateButton(nNumFingers);
              handState = 0;
            } 
            else {
              switchHandState(numFingers);
              handState = numFingers;
            }
          }
        }
      }
    }
    else {
      handStateChangeTimer = 0;
    }

    if (handState == numFingers) {
      PVector[] swFingers = fingers;
      fingers = nFingers;
      nFingers = fingers;
      handStateChangeTimer = 0;
    }
    if (fButtons[nNumFingers] != null) {
      if (handStateChangeTimer < fButtons[nNumFingers].triggerTime - 2) {
        fButtons[nNumFingers].drawLevel(fButtons[nNumFingers].triggerTime - handStateChangeTimer);
      }
    }
  }

  void switchHandState(int newState) {
    if (newState == HANDSTATE_FIVE) {
      //      cPanel.center = new PVector(palmPosition.x, palmPosition.y);
      if (debug) {
        cPanel.center = new PVector(mouseX, mouseY);
      }
      cPanel.open();
    }
    if (cPanel.state == ACTIVE && (newState != HANDSTATE_FIVE)) {
      cPanel.close();
    }
  }

  void click() {
    if (handState == HANDSTATE_FIVE) {
      cPanel.click();
    }
  }

  void setFingerButton(int f, FingerButton b) {
    fButtons[f] = b;
  }

  void removeFingerButton(int f) {
    fButtons[f] = null;
  }

  void removeAllButtons() {
    for (int f = 0; f<5; f++) {
      fButtons[f] = null;
    }
    handState = 0;
    handStateChangeTimer = 0;
    numFingers = 0;
  }

  void draw() {
    for (int i = 0; i < 10; i++) {
      if (fButtons[i] != null) {
        fButtons[i].draw();
      }
    }

    updateHand();

    if ((th.sceneID == SCENE_DIFFUSION_SIMULATION) || (th.sceneID == SCENE_RHODOPSIN_SIMULATION) || (th.sceneID == SCENE_REACTION_SIMULATION)) {
      if (world != null) {
        if (handState == HANDSTATE_ONE) {
          stroke(0);
          ellipse(fingers[0].x, fingers[0].y, 10, 10);        
          // Moving thumb
          world.setPushingForce(new PVector(fingers[0].x, fingers[0].y), 20);
        } 
        else {
          world.noPushing();
        }
        /*
        if (handState  == HANDSTATE_TWO) {
         // Pinzette
         float breite =sqrt(pow(fingers[0].x - fingers[1].x, 2) + pow( fingers[0].y - fingers[1].y, 2));
         
         PVector meanFinger = PVector.add(fingers[0], fingers[1]);
         meanFinger.z = 0;
         meanFinger.mult(0.5);
         PVector dir = fingers[1].get();
         dir.sub(meanFinger);
         line(fingers[0].x, fingers[0].y, fingers[1].x, fingers[1].y);
         noFill();
         strokeWeight(3);
         ellipse(meanFinger.x, meanFinger.y, breite, breite);
         world.setPullingForce(meanFinger, breite);
         } 
         else {
         world.noPulling();
         }
         */
        if (handState == HANDSTATE_FIVE) {
          cPanel.center = new PVector(palmPosition.x, palmPosition.y);
          cPanel.center.x -= width/2 -400;
          cPanel.pointer = new PVector(palmPosition.x - width/2  + 400, palmPosition.y - 80);
          PVector hDir = leap.vectorToPVector(myHand.palmNormal());
          com.leapmotion.leap.Vector hDir2 = myHand.palmNormal();

          cPanel.angle = atan2(hDir2.getX(), hDir2.getY()) / 3.1415926 *360. + 30;
          //          setAngle(fingers);
          //        cPanel.pointer = new PVector(fingers[0].x, fingers[0].y);
          if (debug) {
            cPanel.pointer = new PVector(mouseX, mouseY);
          }

          //    ellipse(palmPosition.x, palmPosition.y, myHand.sphereRadius(), myHand.sphereRadius());
        }
        if (cPanel.state != OFF) {
          cPanel.draw();
        }
      }
    }
  }
  void setAngle(PVector[] f) {
    PVector f1 = new PVector(0, 0);
    PVector f2 = new PVector(0, 0);
    PVector f3 = new PVector(0, 0);

    if ((f[0].x < f[1].x) && (f[0].x < f[2].x)) {
      f1 = f[0];
      if (f[1].x < f[2].x) {
        f2 = f[1];
        f3 = f[2];
        middleFingerID = 1;
      } 
      else {
        f2 = f[2];
        f3 = f[1];
        middleFingerID = 2;
      }
    }
    if ((f[1].x < f[2].x) && (f[1].x < f[0].x)) {
      f1 = f[1];
      if (f[0].x < f[2].x) {
        f2 = f[0];
        f3 = f[2];
        middleFingerID = 0;
      } 
      else {
        f2 = f[2];
        f3 = f[0];
        middleFingerID = 2;
      }
    }
    if ((f[2].x < f[1].x) && (f[2].x < f[0].x)) {
      f1 = f[2];
      if (f[0].x < f[1].x) {
        f2 = f[0];
        f3 = f[1];
        middleFingerID = 0;
      } 
      else {
        f2 = f[1];
        f3 = f[0];
        middleFingerID = 1;
      }
    }
    fingerMID = f2.get();
    PVector d12 = PVector.sub(f1, f2);
    PVector d23 = PVector.sub(f2, f3);
    PVector d31 = PVector.sub(f3, f1);

    float a = atan2(f3.y - f1.y, f3.x - f1.x );
    cPanel.angle = a * 240 + 30;
  }
}



public void screenTapGestureRecognized(ScreenTapGesture gesture) {
  if (gesture.state() == State.STATE_STOP) {    
    PVector p = leap.vectorToPVector(gesture.position());
  } 
  else if (gesture.state() == State.STATE_START) {
  } 
  else if (gesture.state() == State.STATE_UPDATE) {
  }
}

public void circleGestureRecognized(CircleGesture gesture, String clockwiseness) {
  if (gesture.state() == State.STATE_STOP) {
    PVector p = leap.vectorToPVector(gesture.center());
  } 
  else if (gesture.state() == State.STATE_START) {
  } 
  else if (gesture.state() == State.STATE_UPDATE) {
  }
}

public void keyTapGestureRecognized(KeyTapGesture gesture) {
  if (gesture.state() == State.STATE_STOP) {
    //    PVector d = PVector.sub(fingerMID, leap.vectorToPVector(gesture.position()));
    println("Click");
    panel.click();
  } 
  else if (gesture.state() == State.STATE_START) {
  } 
  else if (gesture.state() == State.STATE_UPDATE) {
  }
}

class FingerButton {
  int x, y;
  String t;
  float s;
  int f;
  int triggerTime;

  FingerButton(int finger, int xp, int yp, String text, float size) {
    x = xp;
    y = yp;
    t = text;
    s = size;
    f = finger;
    triggerTime = 25;
  }

  FingerButton(int finger, int xp, int yp, String text, float size, int trig) {
    x = xp;
    y = yp;
    t = text;
    s = size;
    f = finger;
    triggerTime = trig;
  }

  void drawLevel(int level) {
    pushMatrix();
    translate(x, y);
    scale (s * 160. /  500.);
    strokeWeight(8);
    strokeCap(SQUARE);
    for (int a = 0; a < (level *360) / triggerTime; a += 2) {
      pushMatrix();      
      rotate(radians(a));
      line(-3, 250, 3, 250);
      popMatrix();
    }
    popMatrix();
  }

  void draw() {
    pushMatrix();
    translate(x, y);
    pushMatrix();
    scale (s * 160. /  558.);
    tint(255);
    image (imgFinger[f - 1], - 275, - 275);
    popMatrix();
    fill(0);
    textFont(fontB);
    textAlign(CENTER);
    text (t, 0, 100);
    popMatrix();
  }
}

