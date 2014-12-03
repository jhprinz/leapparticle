// ControlPanel

static int OFF = 0;
static int OPENING = 1;
static int ACTIVE = 2;
static int CLOSING = 3;

static int TRANSITION_SPEED = 10;

color[] listOfColors = {
  color(128, 0, 0), color(0, 128, 0), color(0, 0, 128), color(0, 128, 128), color(128, 128, 0)
};

class ControlPanel {
  int state;
  int stateLevel;
  float level;
  int selectedButton;
  int px, py;

  int buttonClicked;
  int buttonClickedTimer;
  int numButtons;

  float angle;

  int size;
  ArrayList<Button> buttons;
  PVector center, pointer;

  ControlPanel(int states, int s) {
    state = OFF;
    selectedButton = 0;
    size = s;
    numButtons = states;

    center = new PVector(width / 2, height / 2);
    pointer = new PVector(width / 2, height / 2);

    PVector dir = new PVector(0, -1);
    dir.rotate(radians(-80));

    buttons = new ArrayList<Button>();

    for (int n = 0; n<states; n++) {        
      buttons.add((Button) new Button(n + 1, dir.get(), str(n + 1)));      
      dir.rotate(radians(160.0 / states));
    }
    buttonClickedTimer = 0;
  }

  void open() {
    state = OPENING;
    stateLevel = 0;
    selectedButton = 0;
  }

  void close() {
    state = CLOSING;
    stateLevel = TRANSITION_SPEED;
  }

  void draw() {
    PVector buttonPos = new PVector(0, 0), bPos, dir, buttonClickedPosition;
    if (state == OPENING) {
      stateLevel++;      
      level = stateLevel / (TRANSITION_SPEED * 1.0);
      if (stateLevel == TRANSITION_SPEED) {
        //      leap.disableGesture(Type.TYPE_CIRCLE);
        //      leap.enableGesture(Type.TYPE_KEY_TAP);
        state = ACTIVE;
      }
    }

    if (state == CLOSING) {
      stateLevel--;      
      level = stateLevel / (TRANSITION_SPEED * 1.0);

      if (stateLevel == 0) {
        //      leap.disableGesture(Type.TYPE_KEY_TAP);
        //      leap.enableGesture(Type.TYPE_CIRCLE);
        state = OFF;
      }
    }

    if (state != OFF) {
      drawState(stateLevel / TRANSITION_SPEED);
    }

    if (stateLevel > 0) {
//      ellipse(pointer.x, pointer.y, 10, 10);
    }

    if (state == ACTIVE) {
      //      selectedButton = 0;
      /*
      dir = new PVector(100, 0);
       float minDist = 50;
       for (int n = 0; n<SIZE; n++) {        
       bPos = center.get();
       bPos.add(dir);      
       if (PVector.dist(pointer, bPos) < minDist) {
       selectedButton = n + 1;
       buttonPos = bPos;
       minDist = PVector.dist(pointer, bPos);
       }
       if (n + 1 == buttonClicked) {
       buttonClickedPosition = bPos;
       }
       dir.rotate(radians(360.0 / SIZE));
       }
       if (selectedButton > 0) {
       stroke(0);
       fill(listOfColors[selectedButton - 1], 128);
       ellipse(buttonPos.x, buttonPos.y, 75, 75);
       }
       if (buttonClickedTimer > 0) {
       buttonClickedTimer--;
       if (buttonClicked > 0) {
       stroke(0);
       fill(255, 0, 0, (255 * buttonClickedTimer ) / 20);
       ellipse(buttonPos.x, buttonPos.y, 75, 75);
       }
       }
       */
       if (buttonClickedTimer > 0) {
         buttonClickedTimer--;
       }
    }
  }

  void click() {
    if ((selectedButton != 0)&&(buttonClickedTimer == 0)) {
      buttonClickedTimer = 2;
      buttonClicked = selectedButton;
      println("Button " + buttonClicked);
      if (buttonClicked == 1) {
        world.add(new RedParticle(center));
      }
      if (buttonClicked == 2) {
        world.add(new GreenParticle(center));
      }
      if (buttonClicked == 3) {
        world.add(new BlueParticle(center));
      }
    }
  }

  void drawState(int level) {
    PVector bPos, bPos2;
    for (Button b : buttons) { 
      b.setSelected();      
      if (b.selected) {
        selectedButton = b.id;
      }
      bPos = b.pos(20);
      bPos2 = b.pos((size - 40) * level);
      strokeWeight(1);
      //      line (bPos2.x, bPos2.y, bPos.x, bPos.y);
      b.draw();
    }
      strokeWeight(2);

    line(center.x, center.y - 30, center.x, center.y - 55);

    stroke(0);
    strokeWeight(2);
    noFill();
    ellipse(center.x, center.y, 45, 45);
    ellipse(center.x, center.y, 40, 40);
    fill(0);
  }

  class Button {
    PVector position; 
    String label;
    int radius;
    boolean selected;  
    int id;

    Button(int i, PVector p, String l) {
      selected = false;
      position = p;
      label = l;
      radius = 80;
      id = i;
    }

    PVector pos() {
      return pos(level*size);
    }

    PVector pos(float m) {
      PVector p = position.get();
      p.rotate(radians(angle));
      return new PVector(center.x + p.x * m, center.y + p.y * m);
    }

    void setSelected() {
      selected = ((PVector.sub(pointer, pos())).mag() < radius / 2.0);
    }

    void draw() {
      stroke(0);
      strokeWeight(3);            
      textAlign(CENTER, CENTER);
      fill(255, 255 * level);
      PVector p = position.get();
      p.rotate(radians(angle));
      ellipse(center.x + p.x * level * size, center.y + p.y * level * size, radius * level, radius * level);
      fill(0);
      text(label, position.x, position.y);
      if (selected) {
        stroke(0);
        strokeWeight(1);
        fill(listOfColors[id - 1], 128);
        ellipse(center.x + p.x * level * size, center.y + p.y * level * size, radius * level - 5, radius * level - 5);
      }
    }
  }
}

