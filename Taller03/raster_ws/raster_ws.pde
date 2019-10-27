import nub.primitives.*;
import nub.core.*;
import nub.processing.*;

// 1. Nub objects
Scene scene;
Node node;
Vector v1, v2, v3;
// timing
TimingTask spinningTask;
boolean yDirection;
boolean anti = false;
// scaling is a power of 2
int n = 4;
int aliLevel = 1;
// 2. Hints
boolean triangleHint = true;
boolean gridHint = true;
boolean debug = true;
boolean axesHint = true;
boolean shadeHint = false;


// 3. Use FX2D, JAVA2D, P2D or P3D
String renderer = P3D;

// 4. Window dimension
int dim = 10;

// Rasterization
color colors[] = new color[3];

void settings() {
  size(int(pow(2, dim)), int(pow(2, dim)), renderer);
}

void setup() {
  rectMode(CENTER);
  scene = new Scene(this);
  if (scene.is3D())
    scene.setType(Scene.Type.ORTHOGRAPHIC);
  scene.setRadius(width/2);
  scene.fit(1);

  // not really needed here but create a spinning task
  // just to illustrate some nub.timing features. For
  // example, to see how 3D spinning from the horizon
  // (no bias from above nor from below) induces movement
  // on the node instance (the one used to represent
  // onscreen pixels): upwards or backwards (or to the left
  // vs to the right)?
  // Press ' ' to play it
  // Press 'y' to change the spinning axes defined in the
  // world system.
  spinningTask = new TimingTask(scene) {
   @Override
    public void execute() {
scene.eye().orbit(scene.is2D() ? new Vector(0, 0, 1) :
       yDirection ? new Vector(0, 1, 0) : new Vector(1, 0, 0), PI / 100);
  }
  };
  scene.registerTask(spinningTask);

  node = new Node();
  node.setScaling(width/pow(2, n));
  // init the triangle that's gonna be rasterized
  randomizeTriangle();
  colors[0] = color(255, 0, 0);
  colors[1] = color(0, 255, 0);
  colors[2] = color(0, 0, 255);
}

void draw() {
  //println(frameRate);
  background(0);
  stroke(0, 255, 0);
  if (gridHint)
    scene.drawGrid(scene.radius(), (int)pow(2, n));
  if (triangleHint)
    drawTriangleHint();
  push();
  scene.applyTransformation(node);
  triangleRaster();
  if (axesHint)
    scene.drawAxes();
  pop();
}


// Implement this function to rasterize the triangle.
// Coordinates are given in the node system which has a dimension of 2^n
void triangleRaster() {
  // node.location converts points from world to noder
  // here we convert v1 to illustrate the idea
  int low = -width/2;
  int high = width/2;
  int lim = 1 << n;
  float step = width / lim;
  
  for (int i = 0; i < lim; ++i) {
    for (int j = 0; j < lim; ++j) {
      float x = map(i, 0, lim, low, high), y = map(j, 0, lim, low, high);
      if (shadeHint)
        continue;
      Vector P = new Vector(x + step / 2, y + step / 2);
      Vector v = node.location(P);
       
      push();
      noStroke();
      
      if (anti)
        fill(aliasing(new Vector(x,y), step, aliLevel));        
      else
        fill(barycentricColor(P));
        
      square(v.x(), v.y(), 1);
      pop();
    }
  }
  if (debug) {
    push();
    noStroke();
    fill(0, 255, 255, 125);
    square(round(node.location(v1).x()), round(node.location(v1).y()), 1);
    pop();
  }
}

void printVector(Vector P) {
  println("Point: ");
  println(P.x(), P.y()); 
}

void randomizeTriangle() {
  int low = -width/2;
  int high = width/2;
  v1 = new Vector(random(low, high), random(low, high));
  v2 = new Vector(random(low, high), random(low, high));
  v3 = new Vector(random(low, high), random(low, high));
}

void randomizeColors() {
  colors[0] = color(random(0, 255), random(0, 255), random(0, 255));
  colors[1] = color(random(0, 255), random(0, 255), random(0, 255));
  colors[2] = color(random(0, 255), random(0, 255), random(0, 255));
}

void drawTriangleHint() {
  push();

  if(shadeHint)
    noStroke();
  else {
    strokeWeight(2);
    noFill();
  }
  beginShape(TRIANGLES);
  if(shadeHint)
    fill(colors[0]);
  else
    stroke(colors[0]);
  vertex(v1.x(), v1.y());
  if(shadeHint)
    fill(colors[1]);
  else
    stroke(colors[1]);
  vertex(v2.x(), v2.y());
  if(shadeHint)
    fill(colors[2]);
  else
    stroke(colors[2]);
  vertex(v3.x(), v3.y());
  endShape();

  strokeWeight(5);
  stroke(colors[0]);
  point(v1.x(), v1.y());
  stroke(colors[1]);
  point(v2.x(), v2.y());
  stroke(colors[2]);
  point(v3.x(), v3.y());

  pop();
}

void keyPressed() {
  if (key == 'a')
    axesHint = !axesHint;
  if (key == 'g')
    gridHint = !gridHint;
  if (key == 't')
    triangleHint = !triangleHint;
  if (key == 's')
    shadeHint = !shadeHint;
  if (key == 'd')
    debug = !debug;
  if (key == '+') {
    n = n < 7 ? n+1 : 2;
    node.setScaling(width/pow( 2, n));
  }
  if (key == 'p') {
    aliLevel = aliLevel < 6 ? aliLevel+1 : 0;
    print(aliLevel);
  }
  if (key == 'n') {
    aliLevel = aliLevel > 0 ? aliLevel-1 : 5;
    print(aliLevel);
  }
  if (key == '-') {
    n = n >2 ? n-1 : 7;
    node.setScaling(width/pow( 2, n));
  }
  if (key == 'r')
    randomizeTriangle();
  if (key == 'c')
    randomizeColors();
  if (key == ' ')
    if (spinningTask.isActive())
      spinningTask.stop();
    else
      spinningTask.run(20);
  if (key == 'y')
    yDirection = !yDirection;
   if (key == 'l')
    anti = !anti;
}