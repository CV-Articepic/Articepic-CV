class Ball {
  float x, y;
  
  Ball() {
    x = random(0, width);
    y = random(0, height);
  }
  
  void update() {
    if (ballRotation) {
      y -= speed * 1.5;
      x += speed;
    } else {
      y -= speed; 
    }
     
    if (y < -padding)
      y = height + padding;
    if (y > height + padding)
    
    if (x < -padding)
      x = width + padding;
    if (x > width + padding)
      x = -padding;
  }
  
  void show() {
    if (!drawBalls)
      return;
    noStroke();
    fill(0, 0, 255);
    for (int i = 0; i < n; ++i) {
        push();
        translate(x, y);
        ellipse(0, 0, 8, 8);        
        pop();
      }
    }
}
