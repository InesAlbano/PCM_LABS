import processing.video.*;
Movie m;

int frames = 1;

int thresholdS= 50000;
int thresholdB= 150000;
PrintWriter file;
PImage previous_frame = createImage(900,500,RGB);
PImage current_frame = createImage(900,500,RGB);

void setup() {
  m = new Movie(this, "PCMLab9.mov");
  size(900,500);
  m.play();
  file = createWriter("data/timeFrame.txt");
  file.println("Frame\t" + "\tHistogram\t" + "\tThreshold1\t" + "\tThreshold2\t");
  file.flush();
}

void draw() {
  if (m.available()) {
    m.read();
    image(m, 0, 0, m.width, m.height);
    transitionDetect();
    frames++;
  }
}

void transitionDetect(){
  int diff = 0;
  int[]previous_hist = new int[256];
  int[]current_hist = new int[256];
  
  if (frames == 1) {
    // pimg.copy(src, sx, sy, sw, sh, dx, dy, dw, dh)
    previous_frame.copy(m, 0, 0, m.width, m.height, 0, 0, m.width, m.height);
    current_frame.copy(m, 0, 0, m.width, m.height, 0, 0, m.width, m.height);
  } else { 
    previous_frame.copy(current_frame, 0, 0, m.width, m.height, 0, 0, m.width, m.height);
    current_frame.copy(m, 0, 0, m.width, m.height, 0, 0, m.width, m.height); 
  }

  
  for (int w = 0; w < m.width; ++w) {
    for (int h = 0; h < m.height; ++h) {
      previous_hist[int(brightness(previous_frame.get(w, h)))]++;
      current_hist[int(brightness(current_frame.get(w, h)))]++;
    }
  }
  
  for(int i = 0; i < 256; i++){
     diff += abs(current_hist[i]-previous_hist[i]);
  }
  
  if(frames == 1){
    file.println(frames  +  "\t\t" + diff + "\t\t\t" + thresholdS + "\t\t\t" + thresholdB);
  } else {
    file.println(frames  +  "\t\t" + diff + "\t\t\t" + thresholdS + "\t\t\t" + thresholdB);
  }
  
  file.flush();
}
