PImage img;

void setup(){
  img = loadImage("PCMLab6.png");
  size(208, 278);
  img.loadPixels();
  
  for (int i = 0; i < img.width * img.height; ++i){
    int Y = int(0.3 * int(img.pixels[i] >> 16 & 0xFF) + 0.59 * int(img.pixels[i] >> 8 & 0xFF) + 0.11 * int(img.pixels[i] & 0xFF));
    img.pixels[i] = Y << 16 | Y << 8 | Y; 
  }
  img.updatePixels();
}

void draw(){
  image(img, 0, 0);
}
    
