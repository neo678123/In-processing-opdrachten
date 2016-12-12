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
Vec3 v;

void setup()
{
  size(1280,720);
  v = new Vec3(2,3,4);
  frameRate(6000);
}

Vec3 dvdt(Vec3 v)
{
  float s = 70;
  float r = 200;
  float b = 80/3;
  
  float dxdt = -s*(v.x - v.y);
  float dydt = (r-v.z) * v.x - v.y;
  float dzdt = v.x * v.y - b * v.z;
  
  return new Vec3(dxdt, dydt, dzdt);
}

void draw()
{
  //clear();
  pushMatrix();
  drawScale();
  
  //Transformeer naar wiskundig assenstelsel
  translate(width/2, height/2);
  scale(1,-1);
  //scale(10,10);
  
  stroke(0,0,0);
  line(0,height,0,-height);
  line(width,0,-width,0);
  
  stroke(0,0,255);
  Vec3 prevV = v;
  Vec3 T = dvdt(v);
  v.x += T.x * dt;
  v.y += T.y * dt;
  v.z += T.z * dt;
  
  line(prevV.x, prevV.z, v.x, v.z);
  
  popMatrix();
  t+=dt;
}

void drawScale()
{
  text("(0,0)",width/2 - 30, height/2 + 10);
  text("(0,360)",width/2 - 40, 10);
  text("(0,-360)",width/2 - 40, height - 10);
  text("(640,0)",width - 40, height/2 + 10);
  text("(-640,0)",10, height/2 + 10); 
}
