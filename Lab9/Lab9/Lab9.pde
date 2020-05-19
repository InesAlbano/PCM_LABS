import processing.video.*;
Movie m;
PrintWriter file1;
int frames1 = 1;
int timer = 2;

PrintWriter file2;
int frames2 = 1;
PImage previous_frame2 = createImage(900,500,RGB);
PImage current_frame2 = createImage(900,500,RGB);

PrintWriter file3;
int frames3 = 1;
int cumulative3 = 0;
PImage previous_frame3 = createImage(900,500,RGB);
PImage current_frame3 = createImage(900,500,RGB);
PImage candidate_frame3 = createImage(900,500,RGB);
boolean candidate3 = false;
float candidateTime3;

PrintWriter file4;
int frames4 = 1;
PImage previous_frame4 = createImage(900,500,RGB);
PImage current_frame4 = createImage(900,500,RGB);

void setup() {
  m = new Movie(this, "ripInPeace.mp4");
  size(900,500);
  m.play();
  m.volume(0);
  file1 = createWriter("data/timeFrame1.txt");
  file1.flush();
  file2 = createWriter("data/timeFrame2.txt");
  file2.flush();
  file3 = createWriter("data/timeFrame3.txt");
  file3.flush();
  file4 = createWriter("data/timeFrame4.txt");
  file4.println("Frame\t" + "\tHistogram\t" + "\tThreshold1\t" + "\tThreshold2\t");
  file4.flush();
}

void draw() {
  if (m.available()) {
    m.read();
    image(m, 0, 0);
    stroboscopicSegmentation(2); // exercise 1
    transitionDetectThreshold(180000); // exercise 2
    transitionDetectTwin(50000, 150000); //exercise 3
    saveTransitions(50000, 150000); // exercise 4
    ++frames1;
    ++frames2;
    ++frames3;
    ++frames4;
  }
}

void stroboscopicSegmentation(int time){ // exercise 1
  if (timer <= m.time())  { // stroboscopic segmentation
      saveFrame("data/frames1/frame" + frames1 + ".png");
      file1.println(nf(m.time(),0, 7));
      file1.flush();
      timer+=time;
    }
}

void transitionDetectThreshold(int threshold){ // exercise 2
  int diff = 0;
  int[]previous_hist = new int[256];
  int[]current_hist = new int[256];
  
  if (frames2 == 1) {
    // pimg.copy(src, sx, sy, sw, sh, dx, dy, dw, dh)
    previous_frame2.copy(m, 0, 0, m.width, m.height, 0, 0, m.width, m.height);
    current_frame2.copy(m, 0, 0, m.width, m.height, 0, 0, m.width, m.height);
    current_frame2.save("data/frames2/frame" + frames2 + ".png");
  } else { 
    previous_frame2.copy(current_frame2, 0, 0, m.width, m.height, 0, 0, m.width, m.height);
    current_frame2.copy(m, 0, 0, m.width, m.height, 0, 0, m.width, m.height); 
  }
  
  for (int w = 0; w < m.width; ++w) {
    for (int h = 0; h < m.height; ++h) {
      previous_hist[int(brightness(previous_frame2.get(w, h)))]++;
      current_hist[int(brightness(current_frame2.get(w, h)))]++;
    }
  }
  
  for(int i = 0; i < 256; i++){
     diff += abs(current_hist[i]-previous_hist[i]);
  }

  if (diff > threshold){
    current_frame2.save("data/frames2/frame" + frames2 + ".png");
    file2.println(nf(m.time(),0, 7));
    file2.flush();
  }
}

void transitionDetectTwin(int thresholdS, int thresholdB){ // exercise 3
  int diff = 0;
  int[]previous_hist = new int[256];
  int[]current_hist = new int[256];
  int[]candidate_hist = new int[256];
  
  if (frames3 == 1) {
    // pimg.copy(src, sx, sy, sw, sh, dx, dy, dw, dh)
    previous_frame3.copy(m, 0, 0, m.width, m.height, 0, 0, m.width, m.height);
    current_frame3.copy(m, 0, 0, m.width, m.height, 0, 0, m.width, m.height);
    current_frame3.save("data/frames3/frame" + frames3 + ".png");
  } else { 
    previous_frame3.copy(current_frame3, 0, 0, m.width, m.height, 0, 0, m.width, m.height);
    current_frame3.copy(m, 0, 0, m.width, m.height, 0, 0, m.width, m.height); 
  }
    
  for (int w = 0; w < m.width; ++w) {
    for (int h = 0; h < m.height; ++h) {
      previous_hist[int(brightness(previous_frame3.get(w, h)))]++;
      current_hist[int(brightness(current_frame3.get(w, h)))]++;
    }
  }
  System.out.println(candidate3);
  if(!candidate3) {
    for(int i =0; i<256;i++){
       diff += abs(current_hist[i]-previous_hist[i]);
    }
  } else {
    for(int i =0; i<256;i++){
       diff += abs(current_hist[i] - candidate_hist[i]);
    }
  }
  
  // If current difference is higher than Tb, then is transition
  if (diff >= thresholdB){
    current_frame3.save("data/frames3/frame" + frames3 + ".png");
    file3.println(nf(m.time(),0, 7));
    file3.flush();
  }
  
  // If current difference is higher than Ts, then it might be transition
  if(diff > thresholdS /*&& diff < thresholdB*/){
    if(candidate3 == false){
      candidate3 = true;
     // cumulative3 = diff;
      candidateTime3 = m.time();
      candidate_frame3.copy(m, 0, 0, m.width, m.height, 0, 0, m.width, m.height); 
      for (int w = 0; w < m.width; ++w) {
        for (int h = 0; h < m.height; ++h) {
          candidate_hist[int(brightness(candidate_frame3.get(w, h)))]++;
        }
      }
    } else {
      cumulative3 += diff; 
    }
  }
  
  // If cumulative difference is higher than Tb, then is transition
  if(diff < thresholdS && cumulative3 >= thresholdB){
    candidate_frame3.save("data/frames3/frame" + frames3 + ".png");
    file3.println(nf(candidateTime3, 0, 7));
    file3.flush();
    cumulative3 = 0;
    candidate3 = false;
  }
  
  if (diff < thresholdS && cumulative3 < thresholdB){
    candidate3 = false;
    cumulative3 = 0;
  }
}

void saveTransitions(int thresholdS, int thresholdB){ // exercise 4
  int diff = 0;
  int[]previous_hist = new int[256];
  int[]current_hist = new int[256];
  
  if (frames4 == 1) {
    // pimg.copy(src, sx, sy, sw, sh, dx, dy, dw, dh)
    previous_frame4.copy(m, 0, 0, m.width, m.height, 0, 0, m.width, m.height);
    current_frame4.copy(m, 0, 0, m.width, m.height, 0, 0, m.width, m.height);
  } else { 
    previous_frame4.copy(current_frame4, 0, 0, m.width, m.height, 0, 0, m.width, m.height);
    current_frame4.copy(m, 0, 0, m.width, m.height, 0, 0, m.width, m.height); 
  }

  
  for (int w = 0; w < m.width; ++w) {
    for (int h = 0; h < m.height; ++h) {
      previous_hist[int(brightness(previous_frame4.get(w, h)))]++;
      current_hist[int(brightness(current_frame4.get(w, h)))]++;
    }
  }
  
  for(int i = 0; i < 256; i++){
     diff += abs(current_hist[i]-previous_hist[i]);
  }
  
  if(frames4 == 1){
    file4.println(frames4  +  "\t\t" + diff + "\t\t\t" + thresholdS + "\t\t\t" + thresholdB);
  } else {
    file4.println(frames4  +  "\t\t" + diff + "\t\t\t" + thresholdS + "\t\t\t" + thresholdB);
  }
  
  file4.flush();
}
