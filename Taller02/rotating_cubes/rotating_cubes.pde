float x,y,z;
int iter = 0, rect_size = 100, rotate = 0;

int iters[] = {100, 100, 200, 300, 500, 800};

void setup() {
  size(1000, 1000, P3D);
  background(255);
  frameRate(256);
  x = width/2;
  y = height/2;
}

void draw() {  
  println(frameRate);
  
  translate(x,y,z);
  rectMode(CENTER);
  noFill();
  
  if (iter == iters.length)
    iter = 0;
  
  //background(255);
  
  
  ++rotate;
  if ( (rotate & 1) == 0) {
    if ( (iter & 1) == 0)
      rotateZ(map(z, 0, iters[iter], 2 * PI, 0));
    else
      rotateZ(map(z, 0, iters[iter], 0, 2 * PI));
  }
  
  
  float center_size = map(z, 0, iters[iter], rect_size, 0);
  
  if (((int) z & 1) == 0) {
    stroke(0);
  } else {
    stroke(255);
  }
  
  rect(0, 0, center_size, center_size);
   
  
   
  if ((iter & 1) == 0) {
    stroke(0);
  } else {
    stroke(255);
  }
  
  for (int i = 0; i < 5; ++i) {
    for (int j = 0; j < 5; ++j) {
      if ( (i & 1) == 0 && (j & 1) == 0) {
        rect(i * rect_size, j * rect_size, rect_size, rect_size);
        rect( -i * rect_size, -j * rect_size, rect_size, rect_size);
        rect(i * rect_size, -j * rect_size, rect_size, rect_size);
        rect( -i * rect_size, j * rect_size, rect_size, rect_size);
      }   
    }
  }
  if ((int) z == iters[iter]) {
    
    z = 0;
    ++iter;
    if ((iter & 1) == 0) {
      //background(255);
    } else {
      //background(0);
    }
  }
  ++z;// The rectangle moves forward as z increments.
  
}
