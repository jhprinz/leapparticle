class Plot {
  int x, y;
  int w, h;
  String label;
  int in;
  int p;

  Plot(int xp, int yp, int wi, int hi) {
    x = xp;
    y = yp;
    w = wi;
    h = hi;
    in = 4;
    p = 0;
    label = "Particles";
  }

  void run() {
    update();
    draw();
  }

  void update() {
  }

  void draw() {
    drawFrame();
    drawData();
  }

  void drawData() {
  }

  void drawFrame() {  
    stroke(0);
    strokeWeight(1);    
    line(x - in, y, x+w, y);
    line(x, y + in, x, y - h);
    line(x + w, y, x + w - in, y - in);
    line(x + w, y, x + w - in, y + in);
    line(x, y - h, x - in, y - h + in);
    line(x, y - h, x + in, y - h + in);
    pushMatrix();
    translate(x - in, y - h / 2);
    rotate(- PI / 2.0);
    textAlign(CENTER, BOTTOM);
    text(label, 0, 0 );
    popMatrix();
    textAlign(CENTER, TOP);
    text("FRAMES", x + w / 2, y + in );
  }
}

class ParticlePlot extends Plot {
  //  plot1.update(world.particleCount[PARTICLE_RED] / 2.0);
  //  plot2.update(world.particleCount[PARTICLE_GREEN] / 2.0);
  int[][] data;
  color[] cols;
  int time;


  ParticlePlot(int x, int y, int wi, int hi) {
    super(x, y, wi, hi);
    data = new int[wi][PARTICLE_TYPES];
    cols = new color[3];
    cols[0] = color(128, 0, 0);
    cols[1] = color(0, 128, 0);
    cols[2] = color(0, 0, 128);
  }

  void update() {
    time++;
    if (time >=w) {
      time = 0;
    }
    for (int i = 0; i < PARTICLE_TYPES; i++) {
      data[time][i] = world.particleCount[i];
    }
  }

  void drawData() {
    float c = 0;
    float tot;
    int t2;
    strokeWeight(1);
    t2 = time + 1;

    for (int t = 0; t<w; t+=1) {
      c = 0;
      tot = 0;
      for (int i = 0; i<3; i++) {
        tot += data[t][i];
      }
      tot = tot / (h - 2 * in);
      t2-=1;
      if (t2 < 0) {
        t2 = w - 1;
      }

      for (int i = 0; i<3; i++) {
        stroke(cols[i]);
        line(x + t2 + in, y - c / tot - in, x + t2 + in, y - (c + data[t][i]) / tot - in);
        c += data[t][i];
      }
    }
  }
}

class NumberPlot extends Plot {
  //  plot1.update(world.particleCount[PARTICLE_RED] / 2.0);
  //  plot2.update(world.particleCount[PARTICLE_GREEN] / 2.0);
  color[] cols;
  int time;
  float lineHeight;
  float barHeight;
  Boolean maxMessage;

  NumberPlot(int x, int y, int wi, int hi) {
    super(x, y, wi, hi);
    cols = new color[4];
    cols[0] = color(128, 0, 0);
    cols[1] = color(0, 128, 0);
    cols[2] = color(0, 0, 128);
    cols[3] = color(255,128,0);
    lineHeight = 80;
    barHeight = 70;
    maxMessage = false;
    in = 5;
  }

  void update() {
  }

  void drawData() {
    float c = 0;
    float tot;
    stroke(0);
    strokeWeight(2);
    textFont(fontA);

    tot = 0;

    for (int i = 0; i<4; i++) {
      fill (cols[i]);
      rect(x + 120, y - i*lineHeight, world.particleCount[i], - barHeight);
      if (world.particleCount[i] < 100) {
        textAlign(LEFT,CENTER);
        text(str(world.particleCount[i]), x + 120 + world.particleCount[i] + 10, y - i*lineHeight - barHeight / 2 - 4);
      } 
      else {
        fill (255);
        textAlign(RIGHT, CENTER);
        text(str(world.particleCount[i]), x + 120 + world.particleCount[i] - 10, y - i*lineHeight - barHeight / 2 - 4);
      }
      tot += world.particleCount[i];
    }

    if ((!maxMessage)&&(tot > 500)) {
      maxMessage = true;
      logS1.add("[WARNUNG] Zu viele Teilchen. Reduzierte Simulationsgeschwindigkeit!");
    }
    if ((maxMessage)&&(tot < 450)) {
      maxMessage = false;
      logS1.add("[HINWEIS] Normale Simulationsgeschwindigkeit wiederhergestellt!");
    }
  }

  void drawFrame() {  
    stroke(0);
    strokeWeight(1);    
    line(x - in, y - 3*lineHeight - barHeight - in, x + w + in, y - 3*lineHeight - barHeight - in);
    line(x - in, y + in, x+w + in, y + in);
    line(x + 110, y, x + 110, y - 3*lineHeight - barHeight);
    textFont(fontB);
    textAlign(RIGHT, CENTER);
    //    text
    text("RED", x + 100, y - 0*lineHeight - barHeight / 2);
    text("GREEN", x + 100, y - 1*lineHeight - barHeight / 2);
    text("BLUE", x + 100, y - 2*lineHeight - barHeight / 2);
        text("YELLOW", x + 100, y - 3*lineHeight - barHeight / 2);
  }
}

