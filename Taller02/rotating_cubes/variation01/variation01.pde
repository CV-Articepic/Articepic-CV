float x,y,z;
int lim = 1000, rect_size = 100, rotate = 0;


void setup() {
  size(720, 720);
  background(255);
  frameRate(256);
  x = width/2;
  y = height/2;
}

void variation1() {
  println(frameRate);
  
  translate(x,y,z);
  
  //background(255);
  
  
  //++rotate;
  if ( (rotate & 1) == 0) {
  }
  
  
  float center_size = map(z * 2, 0, lim, rect_size, 0);
  
  if (((int) z & 1) == 0) {
    stroke(0);
  } else {
    stroke(255);
  }
  
  rect(0, 0, center_size, center_size);
  
  float outer_size = map(z, 0, lim, rect_size, rect_size * 5);
  
  rect(0, 0, outer_size, outer_size);
  ++z;// The rectangle moves forward as z increments.
  if (z == lim) {
    z = 0;
    background(255);
  }
  
}


int step = 0, radius = 100;

int inwards(int x, int y, int m) {
  return (x % m + y % m) % m;
}

int outwards(int x, int y, int m) {
  return (x % m + m - y % m) % m;
}

void variation02() {
  rectMode(CENTER);
  noFill();
  
  int w = 30;
  stroke(0);
  translate(x, y);
  rotate(PI / 4.0);
  for (int i = 0; i < lim; ++i) {
    if (outwards(i, step, w) < w / 2) {
      stroke(0); 
    } else {
      stroke(255); 
    }
    rect(0, 0, i, i);
  }
  for (int i = 90; i >= 0; --i) {
    if (inwards(i, step, w) < w / 2) {
      stroke(255); 
    } else {
      stroke(0); 
    }
    rect(0, 0, i, i);
  }
  stroke(255);
  step += 5; // controls speed of movement
  println(frameRate);
}


void draw() {  
  variation02();
}
