class Squares {
  int n, sign;
  float size, speed, x, y;
  boolean inverse;
  
  Squares(int n, float size, float speed, float x, float y, boolean inverse, int sign) {
    this.n = n;
    this.size = size;
    this.speed = speed;
    this.x = x;
    this.y = y;
    this.inverse = inverse;
    this.sign = sign;
  }
  
  void update() {
    y += speed;
    if (y < -padding)
      y = height + padding;
    if (y > height + padding)
     y = -padding;
  }
  
  void show() {
    noStroke();
    fill(255, 255, 0);
    float spacing = map(y, height, 0, 0, size * 2);
    if (inverse) {
      spacing = map(y, 0, height, 0, size * 2); 
    }
    
    for (int i = 0; i < n; ++i) {
        push();
        translate(x + i * spacing * sign, y);
        rotate(PI / 4.0);
        rect(0, 0, size, size); 
        pop();
      }
    }
}
