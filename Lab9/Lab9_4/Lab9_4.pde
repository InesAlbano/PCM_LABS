import processing.video.*;
Movie mov;

int frame = 1;

int thresholdS= 160000;
int thresholdB= 200000;
PrintWriter file;
PImage previous_frame = createImage(900,500,RGB);
PImage current_frame = createImage(900,500,RGB);

void setup() {
  mov = new Movie(this, "PCMLab9.mov");
  size(900,500);
  mov.play();
  file = createWriter("data/timeFrame.txt");
  file.println("Frame\t" + "\tHistogram\t" + "\tThreshold1\t" + "\tThreshold2\t");
  file.flush();
}

void draw() {
  if (mov.available()) {
    mov.read();
    image(mov, 0, 0, width, height);
    transitionDetect();
    frame++;
  }
}

void getFrames(){  
  if (frame == 1) {
    previous_frame.copy(mov, 0, 0, width, height,0,0,width,height);
    current_frame.copy(mov, 0, 0, width, height,0,0,width,height);
  }
  else { 
    previous_frame.copy(current_frame, 0, 0, width, height,0,0,width,height);
    current_frame.copy(mov, 0, 0, width, height,0,0,width,height); 
  }
}

void transitionDetect(){
  getFrames();
  int currentDiff = 0;
  int[]red_previous_hist = new int[256];
  int[]green_previous_hist = new int[256];
  int[]blue_previous_hist = new int[256];
  int[]red_current_hist = new int[256];
  int[]green_current_hist = new int[256];
  int[]blue_current_hist = new int[256];
  
  // Calculate the histogram
  for (int i = 0; i < mov.width; i++) {
    for (int j = 0; j < mov.height; j++) {
      int red_previous = int(red(previous_frame.get(i, j)));
      int green_previous = int(green(previous_frame.get(i, j)));
      int blue_previous = int(blue(previous_frame.get(i, j)));
      int red_current = int(red(current_frame.get(i, j)));
      int green_current = int(green(current_frame.get(i, j)));
      int blue_current = int(blue(current_frame.get(i, j)));
        
      red_previous_hist[red_previous]++; 
      green_previous_hist[green_previous]++;
      blue_previous_hist[blue_previous]++;
      red_current_hist[red_current]++;
      green_current_hist[green_current]++;
      blue_current_hist[blue_current]++;
    }
  }
  
  currentDiff = calcDiff(currentDiff, red_previous_hist, green_previous_hist, blue_previous_hist, red_current_hist, green_current_hist, blue_current_hist);
  if(frame == 1){
    file.println(frame  +  "\t\t\t" + currentDiff + "\t\t\t" + thresholdS + "\t\t\t" + thresholdB);
  }
  else{
    file.println(frame  +  "\t\t\t" + currentDiff + "\t\t\t" + thresholdS + "\t\t\t" + thresholdB);
  }
  file.flush();
}

int calcDiff(int diff, int[] red_previous_hist, int[] green_previous_hist, int[] blue_previous_hist, int[] red_current_hist, int[] green_current_hist, int[] blue_current_hist){
  for(int i =0; i<256;i++){
     diff = diff + (abs(red_current_hist[i]-red_previous_hist[i]) + abs(green_current_hist[i]-green_previous_hist[i]) + abs(blue_current_hist[i]-blue_previous_hist[i]));
  }
  return diff;
}
