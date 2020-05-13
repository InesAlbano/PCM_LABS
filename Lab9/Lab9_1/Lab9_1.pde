import processing.video.*;
Movie m;
int frames = 1;
int timer = 2;
PrintWriter file;

void setup() {
  m = new Movie(this, "PCMLab9.mov");
  size(900,500);
  m.play();
  //m.volume(0);
  file = createWriter("data/timeFrame.txt");
  file.flush();
}

void draw() {
  if (m.available()) {
    m.read();
    image(m, 0, 0);
    if (timer <= m.time())  { // stroboscopic segmentation
      saveFrame("data/frames/frame" + frames + ".png");
      file.println(nf(m.time(),0, 7));
      file.flush();
      timer+=2;
    }
    ++frames;
  }
}
