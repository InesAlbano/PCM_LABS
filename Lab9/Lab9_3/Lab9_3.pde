import processing.video.*;
Movie m;

int frame = 1;
int cumulative = 0;

boolean candidate = false;
int candidateDiff = 0;
float candidateTime;
int candidateFrame;

int thresholdS= 160000;
int thresholdB= 200000;
PrintWriter file;
PImage previous_frame = createImage(900,500,RGB);
PImage current_frame = createImage(900,500,RGB);
PImage candidate_frame = createImage(900,500,RGB);


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
    image(m, 0, 0, width, height);
    transitionDetect();
    frame++;
  }
}

void transitionDetect(){
  if (frame == 1) {
    previous_frame.copy(m, 0, 0, width, height,0,0,width,height);
    current_frame.copy(m, 0, 0, width, height,0,0,width,height);
    current_frame.save("data/frames/frame" + frame + ".png");
  }
  else { 
    previous_frame.copy(current_frame, 0, 0, width, height,0,0,width,height);
    current_frame.copy(m, 0, 0, width, height,0,0,width,height); 
  }
  int currentDiff = 0;
  int[]previous_hist = new int[256];
  int[]current_hist = new int[256];
  
  for (int i = 0; i < m.width; i++) {
    for (int j = 0; j < m.height; j++) {
      int previous_bright = int(brightness(previous_frame.get(i, j)));
      int current_bright = int(brightness(current_frame.get(i, j)));
      previous_hist[previous_bright]++;
      current_hist[current_bright]++;
    }
  }
  
  currentDiff = calcDiff(currentDiff, current_hist, previous_hist);
  testCandidate(currentDiff);
}

int calcDiff(int diff, int[]current_hist, int[]previous_hist){
  for(int i =0; i<256;i++){
     diff += abs(current_hist[i]-previous_hist[i]);
  }
  return diff;
}

void testCandidate(int currentDiff){
  if (currentDiff>thresholdB){
    current_frame.save("data/frames/frame" + frame + ".png");
    file.println("Frame nº: " + frame + " Time: " + m.time() + "s");
    file.flush();
  }
  
  if(currentDiff > thresholdS && currentDiff < thresholdB){
    if(candidate == false){
      candidate = true;
      cumulative = currentDiff;
      candidateDiff = currentDiff;
      candidateTime = m.time();
      candidateFrame = frame;
      candidate_frame.copy(m, 0, 0, width, height,0,0,width,height); 
    }
    else{
      cumulative += candidateDiff - currentDiff; 
    }
  }
  
  if(currentDiff <= thresholdS && currentDiff >= thresholdB){
    candidate_frame.save("data/frames/frame" + frame + ".png");
    file.println("Frame nº: " + candidateFrame + " Time: " + candidateTime + "s");
    file.flush();
    cumulative = 0;
    candidate = false;
  }
  else{
    cumulative = 0;
    candidate = false;
  }
}
