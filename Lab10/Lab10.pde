import processing.video.*;

Movie m1; 
Movie m2;
Movie m;
Movie other;

PImage frame1;
PImage frame2;
PImage frame;
PImage black = createImage(900, 540, RGB);

int start;
int wipeCounter = 0;
int widthCounter = 0;
int heightCounter = 0;
float fadeTime = 4000;
float dissolveTime = 2000;

boolean wipeFlag = false;
boolean fadeFlag = false;
boolean dissolveFlag = false;
boolean chromaFlag = false;
boolean ourFlag = false;

void setup() {
  black.loadPixels();
  for (int i = 0; i < black.pixels.length; i++) {
    black.pixels[i] = 0; 
  }
  black.updatePixels();
  size(900,540);
  m1 = new Movie(this, "PCMLab10-1.mov");
  m2 = new Movie(this, "PCMLab10-2.mov");
  m = m1;
  other = m2;
  m1.loop();
  m1.volume(0);
  m2.loop();
  m2.volume(0);
}

void movieEvent(Movie m) {
  m.read();
}

void draw() {
  if(wipeFlag) {
    wipe();
  } else if(fadeFlag) {
    fade();
  } else if(dissolveFlag){
    dissolve();
  } else if(chromaFlag) {
    chromaKey();
  } else if(ourFlag) {
    our();
  } else {
    frame = m.get();
    image(frame, 0, 0, width, height);
  }
}

void wipe() {          //exercise 1
  PImage frame1 = m.get();
  PImage frame2 = other.get();
  frame1.resize(900,540);
  frame2.resize(900,540);
  frame1.loadPixels();
  for (int i = 0; i < frame1.width; i++) {
    for (int j = 0; j < frame1.height; j++) {
      int place = i + j * frame1.width;
      if (i < wipeCounter) {
        frame1.pixels[place] = frame2.get(i,j);
      }
    }
  }
  if (wipeCounter < frame1.width) {
    wipeCounter += frame1.width/50;
  }
  else {
    wipeFlag = false;
    wipeCounter = 0;
    Movie temp = m;
    m = other;
    other = temp;
  }
  frame1.updatePixels();
  image(frame1, 0, 0, width, height);
}

void fade() {        //exercise 2
  PImage background;
  float f;
  int time = millis()-start;
  if (time <= fadeTime) {
    if (time <= fadeTime/2) {
      f = map(time, 0, fadeTime/2, 0, 255);
      background = m.get();
    } else {
      f = map(time, fadeTime/2, fadeTime, 255, 0);
      background = other.get();
    } 
    background.resize(900, 540);
    background(background);
    tint(255, f);
    image(black, 0, 0, width, height);
  } else {
    tint(255, 255);
    fadeFlag = false;
    Movie temp = m;
    m = other;
    other = temp;
  }
}

void dissolve() {        //exercise 3
  PImage background;
  float f;
  int time = millis()-start;
  if (time <= dissolveTime) {
    f = map(time, 0, dissolveTime, 0, 255);
    background = m.get();
    background.resize(900, 540);
    background(background);
    tint(255, f);
    image(other, 0, 0, width, height);
  } else {
    tint(255, 255);
    dissolveFlag = false;
    Movie temp = m;
    m = other;
    other = temp;
  }
}

void chromaKey() {        //exercise 4
  frame1 = m1.get();
  frame2 = m2.get();
  frame1.resize(900,540);
  frame2.resize(900,540);
  frame1.loadPixels();
  frame2.loadPixels();

  for (int i = 0; i < frame1.width; i++) {
    for (int j = 0; j < frame1.height; j++) {
      int place = i + j * frame1.width;
      float r = red(frame2.pixels[place]);
      float g = green(frame2.pixels[place]);
      float b = blue(frame2.pixels[place]);
      if (g==255 & (r<250 || b<250)) {
        frame2.pixels[place] = frame1.pixels[place];
      }
    }
  }
  
  frame2.updatePixels();
  image(frame2, 0, 0, width, height);
}

void our() {          //exercise 5
  PImage frame1 = m.get();
  PImage frame2 = other.get();
  frame1.resize(900,540);
  frame2.resize(900,540);
  frame1.loadPixels();
  for (int i = 0; i < frame1.width; i++) {
    for (int j = 0; j < frame1.height; j++) {
      int place = i + j * frame1.width;
      if (i > (frame1.width/2 - widthCounter/2) & i < (frame1.width/2 + widthCounter/2)) {
        if (j > (frame1.height/2 - heightCounter/2) & j < (frame1.height/2 + heightCounter/2)) {
          frame1.pixels[place] = frame2.get(i,j);
        }
      }
    }
  }
  if (widthCounter < frame1.width) {
    widthCounter += frame1.width/50;
  }
  if (heightCounter < frame1.height) {
    heightCounter += frame1.height/50;
  }
  else if (widthCounter >= frame1.width){
    ourFlag = false;
    widthCounter = 0;
    heightCounter = 0;
    Movie temp = m;
    m = other;
    other = temp;
  }
  frame1.updatePixels();
  image(frame1, 0, 0, width, height);
}

void keyPressed() {
  if (key == '1') {
    m = m1;
    other = m2;
  } else if (key == '2') {
    m = m2;
    other = m1;
  } else if (key == 'w') {
    if (wipeFlag == true) {
      wipeFlag = false;
      wipeCounter = 0;
    } else {
      wipeFlag = true;
    }
  } else if (key == 'f') {
    if (fadeFlag == true) {
      fadeFlag = false;
    } else {
      start = millis();
      fadeFlag = true;
    }
  } else if (key == 'd' || key == 'D') {
    if (dissolveFlag == true) {
      dissolveFlag = false;
    } else {
      start = millis();
      dissolveFlag = true;
    }
  } else if (key == 'c') {
    if (chromaFlag == true) {
      chromaFlag = false;
    } else {
      m = m2;
      other = m1;
      chromaFlag = true;
    }
  } else if (key == 'o') {
    if (ourFlag == true) {
      widthCounter = 0;
      heightCounter = 0;
      ourFlag = false;
    } else {
      ourFlag = true;
    }
  }
}
