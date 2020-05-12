import processing.video.*;
Movie mov;
int frame = 1;
int timer = 2;
PrintWriter file;
PImage previous_frame = createImage(900,500,RGB);
PImage current_frame = createImage(900,500,RGB);

void setup() {
  mov = new Movie(this, "PCMLab9.mov");
  size(900,500);
  mov.play();
  file = createWriter("data/timeFrame.txt");
  file.flush();
}

void draw() {
  if (mov.available()) {
    mov.read();
    image(mov, 0, 0);
    stroboSeg();
    frame++;
  }
}

void stroboSeg(){
  if (timer <= mov.time())  {
    saveFrame("data/frames/frame" + frame + ".png");
    file.println("Frame: " + frame  + ", " + "Time: " + mov.time() + "s");
    file.flush();
    timer+=2;
  }
}
