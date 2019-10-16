float x, y, z, rot;



void setup() {
  size(1920, 1080);
  x = width / 2;
  y = height / 2;
  z = 0;
  
  for (int i = 0; i < height / 40 + 1; ++i) {
    for (int j = -1 ; j < width / 160 + 1; ++j) {
      if ((i & 1) == 0) {
        drawSquare(j * 160, i * 40);  
      } else {
        drawSquare(80 + j * 160, i * 40);
      }
            
    }
  }
  
}


float R00 = 0.366 * 255, G00 = 0.470 * 255, B00 = 0.487 * 255;
float R01 = 0.402 * 255, G01 = 0.499 * 255, B01 = 0.484 * 255;

float R10 = 0.640 * 255, G10 = 0.682 * 255, B10 = 0.703 * 255;
float R11 = 0.636 * 255, G11 = 0.658 * 255, B11 = 0.655 * 255;

float R20 = 0.300 * 255, G20 = 0.360 * 255, B20 = 0.359 * 255;
float R21 = 0.369 * 255, G21 = 0.385 * 255, B21 = 0.355 * 255;

void keyPressed() {
  if (key == 's' || key == 'S') {
    println("S pressed");
    saveFrame("roman-###"); 
  } else {
    R00 = random(0, 255);
    R01 = random(0, 255);
    
    G00 = random(0, 255);
    G01 = random(0, 255);
    
    B00 = random(0, 255);
    B01 = random(0, 255);
    
    R10 = random(0, 255);
    R11 = random(0, 255);
    
    G10 = random(0, 255);
    G11 = random(0, 255);
    
    B10 = random(0, 255);
    B11 = random(0, 255);
  
    R20 = random(0, 255);
    R21 = random(0, 255);
    
    G20 = random(0, 255);
    G21 = random(0, 255);
    
    B20 = random(0, 255);
    B21 = random(0, 255);
    
    setup();  
  }
  
}




void drawSquare(float x, float y) {
  push();
  translate(x, y);
  noStroke();
  // 240, 230, 100; 73.3, 78.0, 72.5  
  fill(map(x, 0, width, R10, R11), map(x, 0, width, G10, G11), map(x, 0, width, B10, B11)); 
  beginShape();
  vertex(0, 0);
  vertex(50, 0);
  vertex(80, 40);
  vertex(30, 40);
  endShape();
  
  // 100, 100, 200; 46.7, 52.9, 58.0
  fill(map(y, 0, height, R00, R01), map(y, 0, width, G00, G01), map(y, 0, height, B00, B01));
  beginShape();
  vertex(50, 0);
  vertex(80, 40);
  vertex(110, 0);
  vertex(80, -40);
  endShape();
  
  // 39.6, 42.4, 39.6, 255 123 124
  fill(map(x, 0, width, R20, R21), map(x, 0, width, G20, G21), map(x, 0, width, B20, B21)); 
  beginShape();
  vertex(0, 0);
  vertex(50, 0);
  vertex(80, -40);
  vertex(30, -40);
  endShape();
  pop();
}



void draw() {
}
