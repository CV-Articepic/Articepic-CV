PImage img, pg, pg1, pgTemp, pg1Temp;

int sz = 512;
int padding = 5;

int histavg[] = new int[256], histluma[] = new int[256];  

float[][] edgeDetection = 
                    {{ -1, -1, -1}, 
                    { -1,  8, -1}, 
                    { -1, -1, -1}};
float[][] sharpen = {{ 0, -1, 0}, 
                    { -1,  5, -1}, 
                    { 0, -1, 0}};
float[][] emboss = {{ -2, -1, 0}, 
                    { -1,  1, 1}, 
                    { 0, 1, 2}}; 

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
  pgTemp = pg.copy();
  pg1Temp = pg.copy();
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
int selectionClickX;
int selectionClickY;

void mousePressed() {
  selectionStartX = mouseX;
  selectionStartY = mouseY;
}

void kernelImage(float[][] mascara,PImage img, int posX, int posY ) {
  img.loadPixels();
  PImage edgeImg = createImage(img.width, img.height, RGB);
  for (int y = 1; y < img.height-1; y++) { 
    for (int x = 1; x < img.width-1; x++) {
      float sumR = 0, sumG = 0, sumB = 0;
      for (int ky = -1; ky <= 1; ky++) {
        for (int kx = -1; kx <= 1; kx++) {
          int pos = (y + ky)*img.width + (x + kx);
          float valR = red(img.pixels[pos]);
          float valG = green(img.pixels[pos]);
          float valB = blue(img.pixels[pos]);
          sumR += mascara[ky+1][kx+1] * valR;
          sumG += mascara[ky+1][kx+1] * valG;
          sumB += mascara[ky+1][kx+1] * valB;
        }
      }
      // For this pixel in the new image, set the gray value
      // based on the sum from the kernel
      edgeImg.pixels[y*img.width + x] = color(sumR, sumG, sumB);
    }
  }
  // State that there are changes to edgeImg.pixels[]
  edgeImg.updatePixels();
  image(edgeImg, posX, posY); // Draw the new image
}
int mouseCount1 = 0, mouseCount2 = 0, mouseCount3 = 0;
void mouseClicked() {
  selectionClickX = mouseX;
  selectionClickY = mouseY;
  PImage imgTemp =  img.copy();
  pgTemp =  pg.copy();
  PImage pg1Temp =  pg1.copy();
  if((selectionClickY>0 && selectionClickY<sz))
  {
   if((selectionClickX > 0 && selectionClickX < sz)){
     switch(mouseCount1)
     {
      case 0: 
        mouseCount1++;
        kernelImage(edgeDetection,imgTemp, 0,0);
        break;
      case 1: 
        mouseCount1++;
        kernelImage(sharpen,imgTemp, 0,0);
        break;
      case 2: 
        mouseCount1++;
        kernelImage(emboss,imgTemp, 0, 0);
        break;
      default:     
        mouseCount1 = 0;
        image(imgTemp, 0, 0);
     }
    
  }
   if((selectionClickX > sz && selectionClickX < (sz+padding) * 2)){
     switch(mouseCount2)
     {
      case 0: 
        mouseCount2++;
        kernelImage(edgeDetection,pgTemp, (sz + padding),0);
        break;
      case 1: 
        mouseCount2++;
        kernelImage(sharpen,pgTemp, (sz + padding),0);
        break;
      case 2: 
        mouseCount2++;
        kernelImage(emboss,pgTemp, (sz + padding),0);
        break;
      default:     
        mouseCount2 = 0;
        image(pgTemp, (sz + padding), 0);
     }
  }
   if((selectionClickX > (sz+padding) * 2 && selectionClickX < sz + (sz+padding) * 2)){
     println("entro");
      switch(mouseCount3)
     {
      case 0: 
        mouseCount3++;
        kernelImage(edgeDetection,pg1Temp,(sz + padding) * 2,0);
        break;
      case 1: 
        mouseCount3++;
        kernelImage(sharpen,pg1Temp, (sz + padding) * 2,0);
        break;
      case 2: 
        mouseCount3++;
        kernelImage(emboss,pg1Temp, (sz + padding) * 2,0);
        break;
      default:     
        mouseCount3 = 0;   // don't match the switch parameter
        image(pg1Temp, (sz + padding)*2, 0);
     }
  }
  }
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
