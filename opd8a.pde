float dt = 0.0008f;
float t = 0;

void setup()
{
  size(1280,720, P3D);
  frameRate(60);
  noFill();
  stroke(255);
}

void draw()
{
  clear();
  pushMatrix();

  translate(width/2, height/2);
  translate(200*cos(3*t), 100*cos(5*t + PI/2), 400);
  rotateY(10*t);
  sphere(50);
  
  popMatrix();
  t+=dt;
}
