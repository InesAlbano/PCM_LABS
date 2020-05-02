PImage img;
int rangeSize = 1;
int call = 0;
String number_string = "";

void setup(){
  img = loadImage("PCMLab6.png");
  size(208, 278);
  img.loadPixels();
  if (call!=0) {
    for (int i = 0; i < img.width * img.height; ++i){
      int R = int(red(img.pixels[i]));
      int G = int(green(img.pixels[i]));
      int B = int(blue(img.pixels[i]));
      
      img.pixels[i] = color((R >= rangeSize ? 255 : 0) << 16, (G >= rangeSize ? 255 : 0) << 8, (B >= rangeSize ? 255 : 0));
    }
    call = 0;
  }
  img.updatePixels();
}

void invert() {
  for (int i = 0; i < img.width * img.height; ++i){
    img.pixels[i] = color(255 - int(img.pixels[i] >> 16 & 0xFF), 255 - int(img.pixels[i] >> 8 & 0xFF), 255 - int(img.pixels[i] & 0xFF));
  }
  img.updatePixels();
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
    call = 1;
    rangeSize = int(number_string);
    println("\n" + rangeSize);
    setup();
  } else if (key == 'i') {
    invert();
  } else if (key == 'p') {
    call = 1;
    rangeSize = 128;
    setup();
  }
}
