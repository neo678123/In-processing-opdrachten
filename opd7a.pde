class Vec3
{
  public float x, y, z;
  
  public Vec3(float x, float y, float z)
  {
    this.x = x;
    this.y = y;
    this.z = z;
  }
}

float dt = 0.00008f;
float t = 0;

void setup()
{
  size(1280,720, P3D);
  frameRate(60);
  fill(51);
  stroke(255);
}

void draw()
{
  clear();
  pushMatrix();

  translate(width/2, height/2);
  rotateY(t*200);
  rect(0, 0, 200, 200);
  
  popMatrix();
  t+=dt;
}
