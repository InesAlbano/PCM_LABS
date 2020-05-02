PImage img;
boolean drawH = false;

void setup(){
  img = loadImage("PCMLab8.png");
  //img.resize(416, 556);
  surface.setSize(img.width, img.height);
}

void draw(){
  if (drawH == false) {
    image(img, 0, 0);
  }
}


void keyPressed(){
  if (key == 'l'){
    if (drawH == false) {
      luminanceHist();
      drawH = true;
    } else {
      drawH = false;
    }
  } else if (key == 's') {
    if (drawH == false) {
      //stackedHist();
      drawH = true;
    } else {
      drawH = false;
    }
  }
}
