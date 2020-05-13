import processing.video.*;
Movie m;

int frames = 1;
int cumulative = 0;

boolean candidate = false;
int candidateDiff = 0;
float candidateTime;
int candidateFrame;

int thresholdS= 50000;
int thresholdB= 150000;
PrintWriter file;
PImage previous_frame = createImage(900,500,RGB);
PImage current_frame = createImage(900,500,RGB);
PImage candidate_frame = createImage(900,500,RGB);


void setup() {
  m = new Movie(this, "PCMLab9.mov");
  size(900,500);
  m.play();
  m.volume(0);
  file = createWriter("data/timeFrame.txt");
  file.flush();
}

void draw() {
  if (m.available()) {
    m.read();
    image(m, 0, 0, m.width, m.height);
    transitionDetect();
    ++frames;
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
    current_frame.save("data/frames/frame" + frames + ".png");
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
  
  for(int i =0; i<256;i++){
     diff += abs(current_hist[i]-previous_hist[i]);
  }
  
  // If current difference is higher than Tb, then is transition
  if (diff >= thresholdB){
    current_frame.save("data/frames/frame" + frames + ".png");
    file.println(nf(m.time(),0, 7));
    file.flush();
  }
  
  // If current difference is higher than Ts, then it might be transition
  if(diff > thresholdS && diff < thresholdB){
    if(candidate == false){
      candidate = true;
      cumulative = diff;
      candidateDiff = diff;
      candidateTime = m.time();
      candidateFrame = frames;
      candidate_frame.copy(m, 0, 0, m.width, m.height, 0, 0, m.width, m.height); 
    } else {
      cumulative += candidateDiff - diff; 
    }
  }
  
  // If cumulative difference is higher than Tb, then is transition
  if(cumulative >= thresholdB){
    candidate_frame.save("data/frames/frame" + frames + ".png");
    file.println(nf(candidateTime, 0, 7));
    file.flush();
    cumulative = 0;
    candidate = false;
  }
}
