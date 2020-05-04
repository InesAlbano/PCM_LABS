PImage img;
boolean drawH = false;
String number_string = "";
int macro_pixels = 1;
boolean contrast = false;
boolean mono = false;
boolean bright = false;
int count = 1;

void pixelized(int macro){
  noStroke();
  
  for (int x = 0; x < img.width; x += macro){
    for (int y = 0; y < img.height; y += macro){
      new_pixel_color(x, y, macro);
    }
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

void new_pixel_color(int x, int y, int macro){
  int r = 0, g = 0, b = 0;
  color[][] new_colors = new color[macro][macro];
  for (int i = x; i < macro + x; ++i){
    for (int j = y; j < macro + y; ++j){
      new_colors[i-x][j-y] = img.get(i,j);
    }
  }
 
  int color_matrix_size = (int) Math.pow(new_colors.length, 2);
  
  
  for (int i = 0; i < new_colors.length; ++i){
    for (int j = 0; j < new_colors.length; ++j){
      r += Math.pow(red(new_colors[i][j]), 2);
      g += Math.pow(green(new_colors[i][j]), 2);
      b += Math.pow(blue(new_colors[i][j]), 2);
    }
  }
  
  r = (int) Math.sqrt(r/color_matrix_size);
  g = (int) Math.sqrt(g/color_matrix_size);
  b = (int) Math.sqrt(b/color_matrix_size);
  
  for (int i = 0; i < macro; ++i){
    for (int j = 0; j < macro; ++j){
      //img.pixels[(j+y)*img.width+(i+x)] = color(r,b,g);
      fill(color(r,g,b));
      rect(x,y,macro,macro);
    }
  } 
}

void monochromePix(int value) {
  colorMode(HSB,360,100,100);
  for (int i = 0; i < img.width * img.height; i++) {
    float b = brightness(img.pixels[i]);
    float s = value;
    
    color c = color(120,s,b);
    
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
  img = loadImage("PCMLab8.png");
  surface.setSize(img.width, img.height);
  img.loadPixels();
}

void draw(){
  if (drawH == false) {
    image(img, 0, 0);
  }
  
  if (key == 'e'){
    System.out.println(count);
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
        pixelized(10);
        drawH = true;
      } else {
        drawH = false;
    }
  } else if (key == 'b') {
    if (mono == false) {
      monochromePix(100);
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
