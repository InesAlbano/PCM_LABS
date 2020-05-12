import processing.video.*;
Movie mov;

int frame = 1;
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

ArrayList<Integer> flags;
ArrayList<Integer> diff_frames;
ArrayList<PImage> frames;
ArrayList<Float> time_frames;


void setup() {
  flags = new ArrayList<Integer>();
  time_frames = new ArrayList<Float>();
  frames = new ArrayList<PImage>();
  mov = new Movie(this, "PCMLab9.mov");
  size(900,500);
  mov.play();
  file = createWriter("data/timeFrame.txt");
  file.flush();
}

void draw() {
  image(mov, 0, 0, width, height);
}

void movieEvent(Movie m){
  m.read();
  frames.add(m);
  //time_frames.add(m.time());
  flags.add(0);
  frame++;
}

void transitionDetect(){
  int[]red_current_hist = new int[256];
  int[]green_current_hist = new int[256];
  int[]blue_current_hist = new int[256];
  
  for (int f = 0; f < frames.size(); ++f){
    for (int i = 0; i < mov.width; i++) {
      for (int j = 0; j < mov.height; j++) {
          int red_current = int(red(frames.get(f).get(i, j)));
          int green_current = int(green(frames.get(f).get(i, j)));
          int blue_current = int(blue(frames.get(f).get(i, j)));
          red_current_hist[red_current]++;
          green_current_hist[green_current]++;
          blue_current_hist[blue_current]++;
      }
    }
  }
  
  for (int j = 0; j < 256; j++) {
      System.out.println(red_current_hist[j]);
      }
  
  calcDiff(red_current_hist, green_current_hist, blue_current_hist, false, 0, 0);
  testCandidates(red_current_hist, green_current_hist, blue_current_hist);
}

int calcDiff(int[] red_current_hist, int[] green_current_hist, int[] blue_current_hist, boolean isCandidate, int f1, int f2){
  int diff = 0;
  if (!isCandidate){
    for(int i = 1; i < 256; i++){
       diff = (abs(red_current_hist[i]-red_current_hist[i-1]) + abs(green_current_hist[i]-green_current_hist[i-1]) + abs(blue_current_hist[i]-blue_current_hist[i-1]));
       //diff_frames.add(i, diff);
       if (diff > thresholdS){
         flags.add(i, 1);
       }
    }
  } else { // if it is candate
    diff = (abs(red_current_hist[f2]-red_current_hist[f1]) + abs(green_current_hist[f2]-green_current_hist[f2]) + abs(blue_current_hist[f2]-blue_current_hist[f1]));
  }
  return diff;
}

void testCandidates(int[] red_current_hist, int[] green_current_hist, int[] blue_current_hist){
  int isFirst = 1;
  int firstFrame = 1;
  int diff = 0;
  for (int i = 1; i < flags.size(); ++i){
    if (flags.get(i) == 1){
      if (isFirst == 1) {
        isFirst = 0;
        firstFrame = i;
      } else {
        isFirst = 1;
        firstFrame = i;
        diff = calcDiff(red_current_hist, green_current_hist, blue_current_hist, true, firstFrame, i);
        if (diff > thresholdB){
          frames.get(i).save("data/shots/frame" + frame + ".png");
          file.println("Frame nº: " + frames.get(i)  +  " Difference: " + diff + "Time: " + time_frames.get(i) + "s");
          file.flush();
        }
      }
    }
  }
}

void keyPressed(){
  if (key=='a'){
    transitionDetect();
  }
}
