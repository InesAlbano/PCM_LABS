PImage img;
boolean drawH = false;
String number_string = "";
int macro_pixels = 1;
PImage[] pixels;

void pixelized(int macro){
  int pixel_right = img.width % macro;
  int pixel_bottom = img.height % macro;
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



void setup(){
  img = loadImage("PCMLab8.png");
  surface.setSize(img.width, img.height);
  img.loadPixels();
}

void draw(){
  if (drawH == false) {
    image(img, 0, 0);
  }
}


void keyPressed(){
  if (key == 'a'){
    if (drawH == false) {
      /*if( key >= '0' && key <= '9' ){
        System.out.println("hello");
        number_string += char(key);
        print(key);
      } else if (key == BACKSPACE && number_string.length() > 0 ){
        number_string = number_string.substring(  0, number_string.length()-1 );
     print(key);
     } else if (key == ENTER){
       macro_pixels = int(number_string);
       pixelized(macro_pixels);
     }
      drawH = true;
      number_string = */
      pixelized(10);
      drawH = true;
    } else {
      drawH = false;
    }
  } else if (key == 'b') {
    if (drawH == false) {
      //stackedHist();
      drawH = true;
    } else {
      drawH = false;
    }
  } else if (key == 'c') {
    if (drawH == false) {
      //stackedHist();
      drawH = true;
    } else {
      drawH = false;
    }
  } else if (key == 'd') {
    if (drawH == false) {
      //stackedHist();
      drawH = true;
    } else {
      drawH = false;
    }
  }
}
