float x,y,z;
int  n, step = 0, nballs = 100;

float rect_size = 20, spacing = 0, up = 0, speed = 5, padding = 20;
boolean ballRotation = false, drawBalls = true;
Squares[] left, right;

Ball[] balls;

void setup() {
  size(1000, 1000);
  background(255);
  
  x = width/2;
  y = height/2;
  n = (int) (height / norm(rect_size, rect_size)) + 1;
  left = new Squares[n];
  right = new Squares[n];
  balls = new Ball[nballs];
  
  for (int i = 0; i < n; ++i) {
    float sy = map(i, 0, n, height + padding, -padding);
    right[i] = new Squares(13, rect_size, -speed, x, sy, false, 1);
    left[i] = new Squares(13, rect_size, -speed, x, sy, false, -1);
  }
  
  for (int i = 0; i < nballs; ++i) {
    balls[i] = new Ball(); 
  }
}

float norm(float x, float y) { return sqrt(x * x + y * y); }

int inter = 0;

void mouseClicked() {
  inter = (inter + 1) % 3;
  switch(inter) {
    case 0:
      ballRotation = false;
      for (int i = 0; i < n; ++i) {  
        float sy = map(i, 0, n, height + padding, -padding);
        left[i] = new Squares(13, rect_size, -speed, x, sy, false, -1);
        right[i] = new Squares(13, rect_size, -speed, x, sy, false, 1);
      }
      break;
    case 1:
      for (int i = 0; i < n; ++i) {  
        float sy = map(i, 0, n, height + padding, -padding);
        left[i] = new Squares(13, rect_size, -speed, x, sy, true, -1);
        right[i] = new Squares(13, rect_size, -speed, x, sy, false, 1);
      }
      break;
    case 2:
      ballRotation = true;
      break;
  }  
}

void keyPressed() {
  drawBalls = !drawBalls; 
}


void draw() {
  println(ballRotation);
  background(255);
  
  for (int i = 0; i < nballs; ++i) {
    balls[i].update();
    balls[i].show();
  }
  
  for (int i = 0; i < n; ++i) {
    left[i].update();
    right[i].update();
    
    left[i].show();
    right[i].show();
  }
  
}
