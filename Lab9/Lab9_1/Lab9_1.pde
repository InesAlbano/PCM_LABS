import processing.video.*;
Movie m;
int frames = 1;
int timer = 2;
PrintWriter file;

void setup() {
  m = new Movie(this, "PCMLab9.mov");
  size(900,500);
  m.play();
  file = createWriter("data/timeFrame.txt");
  file.flush();
}

void draw() {
  if (m.available()) {
    m.read();
    image(m, 0, 0);
    stroboSeg();
    frames++;
  }
}

void stroboSeg(){
  if (timer < m.time())  {
    saveFrame("data/frames/frame" + frames + ".png");
    file.println("Frame: " + frames + ", " + "Time: " + m.time() + "s");
    file.flush();
    timer+=2;
  }
}
