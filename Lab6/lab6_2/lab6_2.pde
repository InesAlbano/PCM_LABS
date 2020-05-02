String number_string = "";
int number = 1;
PImage img;

void setup(){
  img = loadImage("PCMLab6.png");
  size(208, 278);
  img.loadPixels();
  for (int i = 0; i < img.width * img.height; ++i){
    img.pixels[i] = color(number * int(img.pixels[i] >> 16 & 0xFF), number * int(img.pixels[i] >> 8 & 0xFF), number * int(img.pixels[i] & 0xFF));
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
    number = int(number_string);
    setup();
  }
}
