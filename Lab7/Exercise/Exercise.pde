import java.util.Map;
import java.util.Comparator;
import java.util.Collections;

PImage img;
boolean drawH = false;
HashMap<Integer,ArrayList<Integer>> hashHist;

HashMap<Integer,ArrayList<Integer>> redHist;
HashMap<Integer,ArrayList<Integer>> greenHist;
HashMap<Integer,ArrayList<Integer>> blueHist;

HashMap<Integer,ArrayList<Integer>> cyanHist;
HashMap<Integer,ArrayList<Integer>> magentaHist;
HashMap<Integer,ArrayList<Integer>> yellowHist;
HashMap<Integer,ArrayList<Integer>> blackHist;


public Comparator<Integer> hueComparator = new Comparator<Integer>() {
  public int compare(Integer s1, Integer s2) {
    Integer h1 = getHue(s1);
    Integer h2 = getHue(s2);
    return h2.compareTo(h1);
    }
};

public int getHue(int c) {
  int red = int(red(c));
  int green = int(green(c));
  int blue = int(blue(c));

  float min = Math.min(Math.min(red, green), blue);
  float max = Math.max(Math.max(red, green), blue);

  if (min == max) { return 0; }

  float hue = 0f;
  if (max == red) { hue = (green - blue) / (max - min); }
  else if (max == green) { hue = 2f + (blue - red) / (max - min); } 
  else { hue = 4f + (red - green) / (max - min); }

  hue = hue * 60;
  if (hue < 0) hue = hue + 360;

  return Math.round(hue);
}

void setup(){
  img = loadImage("PCMLab7.png");
  //img.resize(416, 556);
  surface.setSize(img.width, img.height);
}

void draw(){
  if (drawH == false) {
    image(img, 0, 0);
  }
}

void luminanceHist() {
  hashHist = new HashMap<Integer,ArrayList<Integer>>();

  // Calculate the histogram
  for (int i = 0; i < img.width; i++) {
    for (int j = 0; j < img.height; j++) {
      int p = get(i, j);
      int bright = int(0.3*red(p)+0.59*green(p)+0.11*blue(p));
      
      ArrayList<Integer> pixelsList = hashHist.get(bright);
      if (pixelsList == null) {
        pixelsList = new ArrayList<Integer>();
        hashHist.put(bright, pixelsList);
      }
      pixelsList.add(p);
    }
  }
  
  int histMax = 0;
  
  for (ArrayList<Integer> pixelsList : hashHist.values()) {
    Collections.sort(pixelsList, hueComparator);
    int total = pixelsList.size();
    if (histMax < total) {
      histMax = total;
    }
  }
  
  for (int i = 0; i < img.width; i++) {
    int which = int(map(i, 0, img.width, 0, 256));  // Map i (from 0..img.width) to a location in the histogram (0..255)
    ArrayList<Integer> pixelsList = hashHist.get(which);
    if (pixelsList != null) {
      for (int j = 0; j < pixelsList.size(); j++) {
        int p = pixelsList.get(j);
        // Convert the histogram value to a location between the bottom and the top of the picture
        int y = int(map(j, 0, histMax, img.height, 0));
        stroke(color(p));
        point(i, y);
      }
    }
  }
}

void stackedHist() {
  redHist = new HashMap<Integer,ArrayList<Integer>>();
  greenHist = new HashMap<Integer,ArrayList<Integer>>();
  blueHist = new HashMap<Integer,ArrayList<Integer>>();

  // Calculate the histogram
  for (int i = 0; i < img.width; i++) {
    for (int j = 0; j < img.height; j++) {
      int p = get(i, j);
      int red = int(red(p));
      int green = int(green(p));
      int blue = int(blue(p));
      
      ArrayList<Integer> redList = redHist.get(red);
      if (redList == null) {
        redList = new ArrayList<Integer>();
        redHist.put(red, redList);
      }
      redList.add(p);
      
      ArrayList<Integer> greenList = greenHist.get(green);
      if (greenList == null) {
        greenList = new ArrayList<Integer>();
        greenHist.put(green, greenList);
      }
      greenList.add(p);
      
      ArrayList<Integer> blueList = blueHist.get(blue);
      if (blueList == null) {
        blueList = new ArrayList<Integer>();
        blueHist.put(blue, blueList);
      }
      blueList.add(p);
    }
  }
  
  for (ArrayList<Integer> pixelsList : redHist.values()) {
    Collections.sort(pixelsList, hueComparator);
  }
  
  for (ArrayList<Integer> pixelsList : greenHist.values()) {
    Collections.sort(pixelsList, hueComparator);
  }
  
  for (ArrayList<Integer> pixelsList : blueHist.values()) {
    Collections.sort(pixelsList, hueComparator);
  }
  
  int histMax = 0;
  
  hashHist = new HashMap<Integer,ArrayList<Integer>>();
  for (int i = 0; i < 256; i++) {
    ArrayList<Integer> redPixels = redHist.get(i);
    ArrayList<Integer> greenPixels = greenHist.get(i);
    ArrayList<Integer> bluePixels = blueHist.get(i);
    
    ArrayList<Integer> pixelsList = new ArrayList<Integer>();
    
    hashHist.put(i, pixelsList);
    
    if (redPixels != null) { pixelsList.addAll(redPixels); }
    if (greenPixels != null) { pixelsList.addAll(greenPixels); }
    if (bluePixels != null) { pixelsList.addAll(bluePixels); }
    
    int total = pixelsList.size();
    if (histMax < total) {
      histMax = total;
    }
  }
  
  for (int i = 0; i < img.width; i++) {
    int which = int(map(i, 0, img.width, 0, 256));  // Map i (from 0..img.width) to a location in the histogram (0..255)
    ArrayList<Integer> pixelsList = hashHist.get(which);
    if (pixelsList != null) {
      for (int j = 0; j < pixelsList.size(); j++) {
        int p = pixelsList.get(j);
        // Convert the histogram value to a location between the bottom and the top of the picture
        int y = int(map(j, 0, histMax, img.height, 0));
        stroke(color(p));
        point(i, y);
      }
    }
  }
}

void cmyHist() {
  cyanHist = new HashMap<Integer,ArrayList<Integer>>();
  magentaHist = new HashMap<Integer,ArrayList<Integer>>();
  yellowHist = new HashMap<Integer,ArrayList<Integer>>();
  blackHist = new HashMap<Integer,ArrayList<Integer>>();

  // Calculate the histogram
  for (int i = 0; i < img.width; i++) {
    for (int j = 0; j < img.height; j++) {
      int p = get(i, j);
      int cyan = 255 - int(red(p));
      int magenta = 255 - int(green(p));
      int yellow = 255 - int(blue(p));
      //int cyan = 0;
      //int magenta = 0;
      //int yellow = 0;
      
      int black = min(cyan, magenta, yellow);
      
      //if (black != 255) {
      //  cyan = ((cyan1 - black) / (255 - black)) * 255;
      //  magenta = ((magenta1 - black) / (255 - black)) * 255;
      //  yellow = ((yellow1 - black) / (255 - black)) * 255;
      //}
      
      ArrayList<Integer> cyanList = cyanHist.get(cyan);
      if (cyanList == null) {
        cyanList = new ArrayList<Integer>();
        cyanHist.put(cyan, cyanList);
      }
      cyanList.add(p);
      
      ArrayList<Integer> magentaList = magentaHist.get(magenta);
      if (magentaList == null) {
        magentaList = new ArrayList<Integer>();
        magentaHist.put(magenta, magentaList);
      }
      magentaList.add(p);
      
      ArrayList<Integer> yellowList = yellowHist.get(yellow);
      if (yellowList == null) {
        yellowList = new ArrayList<Integer>();
        yellowHist.put(yellow, yellowList);
      }
      yellowList.add(p);
      
      ArrayList<Integer> blackList = blackHist.get(black);
      if (blackList == null) {
        blackList = new ArrayList<Integer>();
        blackHist.put(black, blackList);
      }
      blackList.add(p);
    }
  }
  
  int histMax = 0;
  
  for (ArrayList<Integer> pixelsList : cyanHist.values()) {
    Collections.sort(pixelsList, hueComparator);
    int total = pixelsList.size();
    if (histMax < total) {
      histMax = total;
    }
  }
  
  for (ArrayList<Integer> pixelsList : magentaHist.values()) {
    Collections.sort(pixelsList, hueComparator);
    int total = pixelsList.size();
    if (histMax < total) {
      histMax = total;
    }
  }
  
  for (ArrayList<Integer> pixelsList : yellowHist.values()) {
    Collections.sort(pixelsList, hueComparator);
    int total = pixelsList.size();
    if (histMax < total) {
      histMax = total;
    }
  }
  
  for (ArrayList<Integer> pixelsList : blackHist.values()) {
    Collections.sort(pixelsList, hueComparator);
    int total = pixelsList.size();
    if (histMax < total) {
      histMax = total;
    }
  }
  
  for (int i = 0; i < img.width; i++) {
    ArrayList<Integer> pixelsList;
    if (i <= img.width / 4) {
      int which = int(map(i, 0, img.width/4, 0, 256));
      pixelsList = cyanHist.get(which);
    } else if (i <= img.width / 2) {
      int which = int(map(i, img.width/4 + 1, img.width/2, 0, 256));
      pixelsList = magentaHist.get(which);
    } else if (i <= 3 * img.width / 4) {
      int which = int(map(i, img.width/2 + 1, 3*img.width/4, 0, 256));
      pixelsList = yellowHist.get(which);
    } else {
      int which = int(map(i,  3*img.width/4 + 1, img.width, 0, 256));
      pixelsList = blackHist.get(which);
    }

    if (pixelsList != null) {
      for (int j = 0; j < pixelsList.size(); j++) {
        int p = pixelsList.get(j);
        // Convert the histogram value to a location between the bottom and the top of the picture
        int y = int(map(j, 0, histMax, img.height, 0));
        stroke(color(p));
        point(i, y);
      }
    }
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
      stackedHist();
      drawH = true;
    } else {
      drawH = false;
    }
  } else if (key == 'c') {
    if (drawH == false) {
      cmyHist();
      drawH = true;
    } else {
      drawH = false;
    }
  }
}
