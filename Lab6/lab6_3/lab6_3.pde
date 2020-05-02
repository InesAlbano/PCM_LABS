String number_string = "";
int threshold;
PImage img;
float bright;
int call = 0;

void setup(){
  img = loadImage("PCMLab6.png");
  size(208, 278);
  img.loadPixels();
  if (call != 0) {
    for (int i = 0; i < img.width * img.height; ++i){
      bright = brightness(img.pixels[i]);
      if (bright < threshold) img.pixels[i] = color(0,0,0);
      else img.pixels[i] = color(255,255,255);  
    }
    img.updatePixels();
    call = 0;
  }
}

void draw(){
  image(img, 0, 0);
}

void keyPressed(){
  if( key >= '0' && key <= '9' ){
    number_string += char(key);
    print(key);
  } else if (key == BACKSPACE && number_string.length() > 0 ){
    number_string = number_string.substring(  0, number_string.length()-1 );   
    print(key);
  } else if (key == ENTER){
    threshold = int(number_string);
    call = 1;
    println("\n" + threshold);
    setup();
  }
}
