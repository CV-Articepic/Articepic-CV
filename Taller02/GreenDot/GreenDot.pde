float px, py, px2, py2;
float angle, angle2;
float radius = 50;
float frequency = 2;
float frequency2 = 2;
float x, x2;
 void setup()
 {
   size(500,500);
   angle = 15;
     
 }
 void draw()
 {
 background(167);
translate(width/2,height/2);
filter(BLUR,0);
stroke(0);
line(0,-10,0,10);
line(-10,0,10,0);
noStroke();
  for(int i = 0; i < 13; i++)
   {
    px = cos(radians(angle))*(200);
    py = sin(radians(angle))*(200);
    px2 = cos(radians(angle+30))*(200);
    py2 = sin(radians(angle+30))*(200);
     fill(252, 196, 255);
     circle(px, py, 55);
     fill(167);
     circle(px2, py2, 60);
     angle = angle+30;
     delay(2);
   }
  
    filter(BLUR,6);
 }
