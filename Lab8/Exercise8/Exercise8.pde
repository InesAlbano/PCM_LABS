PImage img;
boolean drawH = false;
int macro_pixels = 1;
boolean contrast = false;
boolean mono = false;
boolean bright = false;
int count = 1;

void pixelized(int macro){
  noStroke();
  int pixWidth = img.width % macro;
  int pixHeight = img.height % macro;

  for (int x = 0; x < img.width - pixWidth; x += macro){
    for (int y = 0; y < img.height - pixHeight; y += macro){
      new_pixel_color(x, y, macro, macro);
    }
  } 

  if(pixWidth != 0) {
    for (int y = 0; y < img.height-macro; y += macro){
      new_pixel_color(img.width-pixWidth, y, pixWidth, macro);
    }
  }
   
   if (pixHeight != 0) {
    for (int y = 0; y < img.width-macro; y += macro){
      new_pixel_color(y, img.height-pixHeight, macro, pixHeight);
    }
  }
  
  if(pixWidth != 0 && pixHeight != 0) {
    new_pixel_color(img.width-pixWidth,img.height-pixHeight, pixWidth, pixHeight);
  }
  /* Other way
  for (int x = 0; x < img.width ; x += macro){
    for (int y = 0; y < img.height; y += macro){
      update_color(x,y,macro);
    }
  }*/
  
  img.updatePixels();
}

void update_color(int x, int y, int macro){
  color c = img.pixels[y*img.width + x];
  fill(c);
  rect(x,y,macro,macro);
}

void new_pixel_color(int x, int y, int macroW, int macroY){
  int r = 0, g = 0, b = 0;
  color[][] new_colors = new color[macroW][macroY];
  for (int i = x; i < macroW + x; ++i){
    for (int j = y; j < macroY + y; ++j){
      new_colors[i-x][j-y] = img.get(i,j);
    }
  }
 
  int color_matrix_size = (int) macroW * macroY;
  
  
  for (int i = 0; i < macroW; ++i){
    for (int j = 0; j < macroY; ++j){
      r += red(new_colors[i][j]);
      g += green(new_colors[i][j]);
      b += blue(new_colors[i][j]);
    }
  }
  
  r = (int) (r/color_matrix_size);
  g = (int) (g/color_matrix_size);
  b = (int) (b/color_matrix_size);
  
  for (int i = 0; i < macroW; ++i){
    for (int j = 0; j < macroY; ++j){
      //img.pixels[(j+y)*img.width+(i+x)] = color(r,b,g);
      fill(color(r,g,b));
      rect(x,y,macroW,macroY);
    }
  } 
}
void monochromePix(int value) {
  colorMode(HSB,360,100,100);
  for (int i = 0; i < img.width * img.height; i++) {
    float b = brightness(img.pixels[i]);
    
    color c = color(value,75,b);
    
    img.pixels[i] = c;
  }
  img.updatePixels();
  colorMode(RGB, 255,255,255);
}

//Alinea 3
void changeBrightness(int number) {
  for (int i = 0; i < img.width * img.height; ++i){
    img.pixels[i] = color(number * int(img.pixels[i] >> 16 & 0xFF), number * int(img.pixels[i] >> 8 & 0xFF), number * int(img.pixels[i] & 0xFF));
  }
  img.updatePixels(); 
}

void changeContrast(int value) {
  for(int i = 0; i < img.width * img.height; i++) {
    float r,g,b;
    
     r = red(img.pixels[i]);
     g = green(img.pixels[i]);
     b = blue(img.pixels[i]);
     
     r = value * (r - 127) + 127;
     g = value * (g - 127) + 127;
     b = value * (b - 127) + 127;
     
     
     color c = color(r,g,b);
     
     img.pixels[i] = c;
  }
  img.updatePixels();
}

void setup(){
  colorMode(RGB,255,255,255);
  img = loadImage("hellothere.jpg");
  surface.setSize(img.width, img.height);
  img.loadPixels();
}

void draw(){
  if (drawH == false) {
    image(img, 0, 0);
  }
  
  if (key == 'e'){
    if(count <= 10) {
      pixelized(count);
      count++;
    }
    else {
      pixelized(count);
    }
  }
  
  else if (key == 'f') {
    count = 1;
  }
  
}

void keyPressed(){
    if (key == 'a'){
      if (drawH == false) {
        pixelized(16);
        drawH = true;
      } else {
        drawH = false;
    }
  } else if (key == 'b') {
    if (mono == false) {
      monochromePix(267);
      mono = true;
    } else {
      setup();
      mono = false;
    }
  } else if (key == 'c') {
    if (bright == false) {
      changeBrightness(3);
      bright = true;
    } else {
      setup();
      bright = false;
    }
  } else if (key == 'd') {
    if (contrast == false) {
      //stackedHist();
      changeContrast(5);
      contrast = true;
    } else {
      setup();
      contrast = false;
    }
  }
}
