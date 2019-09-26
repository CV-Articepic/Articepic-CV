PImage img, pg, pg1;

int sz = 512;
int padding = 5;

int histavg[] = new int[256], histluma[] = new int[256];  

void setup() {
  size(1550, 1200);
  img = loadImage("lenna.png");
  pg = createImage(img.width, img.height, RGB);
  pg1 = createImage(img.width, img.height, RGB);
    
  loadPixels();
  /*for (int i = 0; i < pixels.length; ++i) {
    float r = random(255);
    float g = random(255);
    float b = random(255);
    
    color c = color(r, g, b);
    pixels[i] = c;
  }
  updatePixels();
  */
  background(0);
  
  img.loadPixels();
  pg.loadPixels();
  pg1.loadPixels();
  
  
  for (int x = 0; x < img.width; ++x) {
    for (int y = 0; y < img.height; ++y) {
       int loc = x + y * img.width;
       float r = red(img.pixels[loc]);
       float g = green(img.pixels[loc]);
       float b = blue(img.pixels[loc]);
       
       float avg = (r + g + b) / 3;
       float luma = r * 0.2126 + g * 0.7152 + b * 0.0722;
       
       pg.pixels[loc] = color(avg);
       pg1.pixels[loc] = color(luma);
       
       //hist
       ++histavg[int(avg)];
       ++histluma[int(luma)];
    }
  }
  
  int histavgMax = max(histavg);
  int histlumaMax = max(histluma);
  
  pg.updatePixels();
  pg1.updatePixels();
  
  image(img, 0, 0);
  image(pg, sz + padding, 0);
  image(pg1, (sz + padding) * 2, 0);
  
  stroke(255);
  
  for (int i = 0; i < sz; i += 2) {
    // Map i (from 0..img.width) to a location in the histogram (0..255)
    int which = int(map(i, 0, sz, 0, 255));
    // Convert the histogram value to a location between 
    // the bottom and the top of the picture
    int y = int(map(histavg[which], 0, histavgMax, img.height, 0));
    int y2 = int(map(histluma[which], 0, histlumaMax, img.height, 0));
    line(i+sz+padding, sz * 2 + padding, i+sz+padding, sz + y + padding);
    line(i+(sz+padding) * 2, sz * 2 + padding, i+(sz+padding) * 2, sz + y2 + padding);
  } 
}

int selectionStartX, selectionStartY, selectionEndX, selectionEndY;

void mousePressed() {
  selectionStartX = mouseX;
  selectionStartY = mouseY;
}


void updateImage(PImage canvas, int x1, int x2, int hist[], boolean luma) {
  int inter1 = max(x1, selectionStartX), inter2 = min(x2, selectionEndX);
  if (inter1 > inter2) {
    return;
  }
  int which1 = int(map(inter1,  x1, x2, 0, 255));
  int which2 = int(map(inter2,  x1, x2, 0, 255));
  
  img.loadPixels();
  canvas.loadPixels();
  
  for (int x = 0; x < img.width; ++x) {
    for (int y = 0; y < img.height; ++y) {
       int loc = x + y * img.width;
       float r = red(img.pixels[loc]);
       float g = green(img.pixels[loc]);
       float b = blue(img.pixels[loc]);
       
       float value;
       if (luma) {
         value = r * 0.2126 + g * 0.7152 + b * 0.0722;  
       } else {
         value = (r + g + b) / 3;  
       }
       
       if (which1 <= value && value <= which2) {
         canvas.pixels[loc] = color(value);
       } else {
         canvas.pixels[loc] = color(0); 
       }
    }
  }
  println("upd img\n");
  int histMax = max(hist);
  for (int i = 0; i < sz; i += 2) {
    int which = int(map(i, 0, sz, 0, 255)); 
    int y = int(map(hist[which], 0, histMax, canvas.height, 0));
    if (which1 <= which && which <= which2) {
      stroke(color(255, 255, 0));
    } else {
      stroke(255);
    }
    line(i+x1, sz * 2 + padding, i+x1, sz + y + padding);
  }
  
  canvas.updatePixels();
  image(canvas, x1, 0);
}
 
void mouseReleased() {
  selectionEndX = mouseX;
  selectionEndY = mouseY;
  if (selectionStartY <= sz || selectionEndY <= sz) {
    println(selectionStartY +" "+ selectionEndY);
    return;
  }
  // XOR Swap Algorithm
  if (selectionEndX < selectionStartX) {
    selectionStartX ^= selectionEndX;
    selectionEndX ^= selectionStartX;
    selectionStartX ^= selectionEndX; 
  }
  
  int x1 = sz + padding, x2 = sz * 2 + padding;
  int x3 = (sz+padding) * 2, x4 = sz + (sz+padding) * 2; 
  
  updateImage(pg, x1, x2, histavg, false);
  updateImage(pg1, x3, x4, histluma, true);
}

void draw() {
}
