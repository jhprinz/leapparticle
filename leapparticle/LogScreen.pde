class LogScreen {
  int x, y, w, h;

  String[] logText;
  int[] logWait;

  int maxLength;

  int time;
  int mode;

  int posAct;
  int lineAct;
  int posEnd;
  int lineEnd;
  int lineHeight;
  int cx, cy;

  Boolean active;
  Boolean border;

  int cursorTimer;

  LogScreen(int xp, int yp, int wid, int hei) {
    lineEnd = 0;
    time = 0;
    posAct = 0;
    lineAct = 0;
    posEnd = 0;
    lineEnd = -1;
    lineHeight = 30;
    maxLength = hei / lineHeight;
    border = true;
    logText = new String[maxLength];
    logWait = new int[maxLength];

    for (int i = 0; i < maxLength; i++) {
      logText[i] = "";
      logWait[i] = 0;
    }
    x = xp;
    y = yp;
    w = wid;
    h = hei;
    cx = xp;
    cy = yp;
    
    active = false;
    cursorTimer = 0;
  }
  
  void got(int i) {
    lineAct = i;
    lineEnd = i;
  }

  void add(String t) {
    add(t, 10);
  }

  void add(String t, int w) {
    if (lineEnd == maxLength - 1) {
      lineEnd--;
      for (int i = 0; i < maxLength - 1; i++) {
        logText[i] = logText[i + 1];
      }
      lineAct--;
    }
    lineEnd ++;
    logText[lineEnd] = t;
    logWait[lineEnd] = w;
  }

  void run() {
    time --;
    if (time <= 0) {
      if (lineAct <= lineEnd) {
        if (posAct < logText[lineAct].length()) {
          posAct++;
          time = 1;
        }       
        else {
          posAct = 0;
          time = logWait[lineAct];
          lineAct++;
        }
      } 
      else {
        time = 1;
      }
    }
    draw();
  }

  void drawCursor() {
    cursorTimer++;
    if (cursorTimer < 10) {
      if (lineAct > lineEnd) {
        cx = 0;
      } 
      else {
        String s = logText[lineAct].substring(0, posAct);
        cx = (int)textWidth(s);
      }
      cy = lineAct * lineHeight;
      cx += x;
      cy += y;
      fill(0);
      strokeWeight(2);
      line(cx, cy + 4, cx, cy - 20);
    }
    if (cursorTimer > 20) {
      cursorTimer = 0;
    }
  }

  void draw() {
    if (active) {
      stroke(0);
      strokeWeight(1);
      if (border) {
        line(x - 5, y - 30, x + w + 5, y - 30);
        line(x - 5, y + h, x + w + 5, y + h);
      }
      
      fill(0);
      textAlign(LEFT);
      if (lineAct >= 0) {
        for (int l = 0; l < lineAct; l++) {
          text(logText[l], x, y + l * lineHeight);
        }
        if (lineAct <= lineEnd) {
          String sString = logText[lineAct];
          sString = sString.substring(0, posAct);

          text(sString, x, y + lineAct * lineHeight);
        }
      }
      drawCursor();
    }
  }
}
