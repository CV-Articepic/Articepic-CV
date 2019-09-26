PImage img, imgCanvas, imgAvg, imgLuma, avgCanvas, lumaCanvas;

int sz = 512;
int padding = 5;

int histavg[] = new int[256], histluma[] = new int[256];  
int avgw1, avgw2, lumaw1, lumaw2;

float[][] edgeDetection = 
  {{ -1, -1, -1}, 
  { -1, 8, -1}, 
  { -1, -1, -1}};
float[][] sharpen = {{ 0, -1, 0}, 
  { -1, 5, -1}, 
  { 0, -1, 0}};
float[][] emboss = {{ -2, -1, 0}, 
  { -1, 1, 1}, 
  { 0, 1, 2}}; 

void setup() {
  size(1550, 1200);
  img = loadImage("lenna.png");
  imgAvg = createImage(img.width, img.height, RGB);
  imgLuma = createImage(img.width, img.height, RGB);

  background(0);

  img.loadPixels();
  imgAvg.loadPixels();
  imgLuma.loadPixels();


  for (int x = 0; x < img.width; ++x) {
    for (int y = 0; y < img.height; ++y) {
      int loc = x + y * img.width;
      float r = red(img.pixels[loc]);
      float g = green(img.pixels[loc]);
      float b = blue(img.pixels[loc]);

      float avg = (r + g + b) / 3;
      float luma = r * 0.2126 + g * 0.7152 + b * 0.0722;

      imgAvg.pixels[loc] = color(avg);
      imgLuma.pixels[loc] = color(luma);

      //hist
      ++histavg[int(avg)];
      ++histluma[int(luma)];
    }
  }


  imgAvg.updatePixels();
  imgLuma.updatePixels();

  imgCanvas = img.copy();
  avgCanvas = imgAvg.copy();
  lumaCanvas = imgLuma.copy();

  image(img, 0, 0);
  image(imgAvg, sz + padding, 0);
  image(imgLuma, (sz + padding) * 2, 0);

  stroke(255);
  avgw1 = lumaw1 = 0;
  avgw2 = lumaw2 = 255;

  drawHist(imgAvg, sz+padding, avgw1, avgw2, false);
  drawHist(imgLuma, (sz+padding)*2, lumaw1, lumaw2, true);
}


int[] getHist(PImage img, boolean luma) {
  int hist[] = new int[256];
  img.loadPixels();
  for (int x = 0; x < img.width; ++x) {
    for (int y = 0; y < img.height; ++y) {
      int loc = x + y * img.width;
      
      float r = red(img.pixels[loc]);
      float g = green(img.pixels[loc]);
      float b = blue(img.pixels[loc]);

      float val;
      if (luma) {
        val = r * 0.2126 + g * 0.7152 + b * 0.0722;
      } else {
        val = (r + g + b) / 3;
      }
      ++hist[int(val)];
    }
  }
  for (int i = 0; i < 256; ++i) {
    println(i +" " + hist[i]);
  }
  return hist;
}

void drawHist(PImage img, int X, int which1, int which2, boolean luma) {
  int hist[] = getHist(img, luma);
  int histMax = max(hist);
  stroke(0);
  for (int i = 0; i < sz; ++i)
    line(i+X, sz * 2 + padding, i+X, sz + padding);

  for (int i = 0; i < sz; i += 2) {
    // Map i (from 0..img.width) to a location in the histogram (0..255)
    int which = int(map(i, 0, sz, 0, 255));
    // Convert the histogram value to a location between 
    // the bottom and the top of the picture
    int y = int(map(hist[which], 0, histMax, img.height, 0));
    //println("i:" + i + " " +y);
    if (y == 0) {
      println(which + "wryyy");
      println(hist[which]);
    }
    if (which1 <= which && which <= which2) {
      stroke(color(255, 255, 0));
    } else {
      stroke(255);
    }
    line(i+X, sz * 2 + padding, i+X, sz + padding + y);
  }
}

int selectionStartX, selectionStartY, selectionEndX, selectionEndY;
int selectionClickX;
int selectionClickY;

void drawInterval(PImage img, int posX, int which1, int which2, boolean luma) {
  img.loadPixels();
  PImage canvas = createImage(img.width, img.height, RGB);
  canvas.loadPixels();
  for (int x = 0; x < img.width; ++x) {
    for (int y = 0; y < img.height; ++y) {
      int loc = x + y * img.width;
      float r = red(img.pixels[loc]);
      float g = green(img.pixels[loc]);
      float b = blue(img.pixels[loc]);

      float val;
      if (luma) {
        val = r * 0.2126 + g * 0.7152 + b * 0.0722;
      } else {
        val = (r + g + b) / 3;
      }
      if (which1 <= val && val <= which2) {
        canvas.pixels[loc] = img.pixels[loc];
      } else {
        canvas.pixels[loc] = 0;
      }
    }
  }
  canvas.updatePixels();
  image(canvas, posX, 0);
}

PImage kernelImage(float[][] mascara, PImage img) {
  PImage canvas = createImage(img.width, img.height, RGB);
  canvas.loadPixels();
  img.loadPixels();
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
      canvas.pixels[y*img.width + x] = color(sumR, sumG, sumB);
    }
  }
  // State that there are changes to edgeImg.pixels[]
  return canvas;
  //canvas.updatePixels();
  //image(canvas, posX, posY); // Draw the new image
  //drawHist(canvas, posX);
}

int mouseCount1 = 0, mouseCount2 = 0, mouseCount3 = 0;
void mouseClicked() {
  selectionClickX = mouseX;
  selectionClickY = mouseY;

  if ((selectionClickY>0 && selectionClickY<sz)) {
    if ((selectionClickX > 0 && selectionClickX < sz)) {
      switch(mouseCount1) {
      case 0: 
        mouseCount1++;
        imgCanvas = kernelImage(edgeDetection, img);
        break;
      case 1: 
        mouseCount1++;
        imgCanvas = kernelImage(sharpen, img);
        break;
      case 2: 
        mouseCount1++;
        imgCanvas = kernelImage(emboss, img);
        break;
      default:     
        mouseCount1 = 0;
        imgCanvas = img;
      }
      image(imgCanvas, 0, 0);  
    }

    if ((selectionClickX > sz && selectionClickX < (sz+padding) * 2)) {
      switch(mouseCount2) {
      case 0: 
        mouseCount2++;
        avgCanvas = kernelImage(edgeDetection, imgAvg);
        break;
      case 1: 
        mouseCount2++;
        avgCanvas =kernelImage(sharpen, imgAvg);
        break;
      case 2: 
        mouseCount2++;
        avgCanvas = kernelImage(emboss, imgAvg);
        break;
      default:     
        mouseCount2 = 0;
        avgCanvas = imgAvg;
      }
      drawInterval(avgCanvas, sz+padding, avgw1, avgw2, false);
      drawHist(avgCanvas, sz+padding, avgw1, avgw2, false);
    } 

    if ((selectionClickX > (sz+padding) * 2 && selectionClickX < sz + (sz+padding) * 2)) {
      switch(mouseCount3) {
      case 0: 
        mouseCount3++;
        lumaCanvas = kernelImage(edgeDetection, imgLuma);
        break;
      case 1: 
        mouseCount3++;
        lumaCanvas = kernelImage(sharpen, imgLuma);
        break;
      case 2: 
        mouseCount3++;
        lumaCanvas = kernelImage(emboss, imgLuma);
        break;
      default:     
        mouseCount3 = 0;   // don't match the switch parameter
        lumaCanvas = imgLuma;
      }
      drawInterval(lumaCanvas, (sz+padding) * 2, lumaw1, lumaw2, true);
      drawHist(lumaCanvas, (sz+padding) * 2, lumaw1, lumaw2, true);
    }
  }
}

void updateImage(PImage canvas, int x1, int x2, boolean luma) {
  int inter1 = max(x1, selectionStartX), inter2 = min(x2, selectionEndX);
  if (inter1 > inter2) {
    return;
  }
  int which1 = int(map(inter1, x1, x2, 0, 255));
  int which2 = int(map(inter2, x1, x2, 0, 255));
  drawInterval(canvas, x1, which1, which2, luma);
  drawHist(canvas, x1, which1, which2, luma);
  if (luma) {
    lumaw1 = which1;
    lumaw2 = which2;
  } else {
    avgw1 = which1;
    avgw2 = which2;
  }
}

void mousePressed() {
  selectionStartX = mouseX;
  selectionStartY = mouseY;
}

void mouseReleased() {
  selectionEndX = mouseX;
  selectionEndY = mouseY;
  if (selectionStartY <= sz || selectionEndY <= sz) {
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
  updateImage(avgCanvas, x1, x2, false);
  updateImage(lumaCanvas, x3, x4, true);
}

void draw() {
}
