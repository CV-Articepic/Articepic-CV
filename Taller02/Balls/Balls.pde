import processing.sound.*;
SoundFile file;
int x = 0;
int y = 0;
boolean click = false;
void setup()
{
size(800,800, P3D);
file = new SoundFile(this, "Bounce.mp3");
}
void draw()
{
background(0);
noStroke();
lights();
pushMatrix(); 
translate(772-x, 28+y, 28);
fill(58, 102, 132);
sphere(28);
popMatrix();
pushMatrix(); 
if(click)
{
fill(255, 102, 132);
}
translate(28+x, 28+y, 0);
sphere(28);
popMatrix();
x = x +9;
y = y +9;
if(x >= 800)
{
  x = 0;
  y = 0;
}
if(x == 252)
{
  file.play();
}

}
void mousePressed()
{
  click = true;
}
void mouseReleased()
{
  click = false;
}
