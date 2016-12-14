float dt = 0.00008f;
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

  translate(2*width/3, height/2, 100);
  rotateY(t*200);
  box(100);
  rotateY(-t*200);
  translate(-2*width/3, -height/2, -100);
  
  translate(width/3, height/2);
  rotateX(t*200);
  rotateY(t*200);
  box(100);
  rotateY(-t*200);
  rotateX(-t*200);
  translate(-width/3, -height/2);
  
  popMatrix();
  t+=dt;
}
