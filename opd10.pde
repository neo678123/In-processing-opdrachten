final float pi = 3.1415;

class Vec3
{
  public float x, y, z;
  
  public Vec3(float x, float y, float z)
  {
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  public float sqrmag() { return x*x+y*y+z*z;}
  public float mag() { return sqrt(sqrmag()); }
  
  public float distance(Vec3 v)
  {
    Vec3 u = new Vec3(x-v.x, y-v.y, z-v.z);
    return u.mag();
  }
}

public class Sphere
{
  Vec3 pos;
  float r;
  
  public Sphere(Vec3 pos, float r)
  {
     this.pos = pos;
     this.r = r;
  }
  
  public void draw(int red, int green, int blue)
  {
      fill(red,green,blue);
      translate(pos.x, pos.y, pos.z);
      sphere(r);
      translate(-pos.x, -pos.y, -pos.z);
  }
}

public class Planet extends Sphere
{ 
  final float k = 20000f;
  float thisR, starR;
  Vec3 starPos, velocity, acceleration;
  
  public Planet(Vec3 pos, Sphere star, float r)
  {
    super(pos,r);
    thisR = r;
    starR = star.r;
    
    starPos = star.pos;
    
    velocity = acceleration = new Vec3(0,0,0);
  }
  
  public void updatePos()
  {
    Vec3 r = new Vec3(starPos.x - pos.x, starPos.y - pos.y, starPos.z - pos.z);
    float C = k * (4/3 * pi * cube(starR)) / cube(r.mag());
    
    acceleration = new Vec3(C * r.x, C * r.y, C * r.z);
    velocity = new Vec3(velocity.x + acceleration.x * dt, velocity.y + acceleration.y * dt, velocity.z + acceleration.z * dt);
    pos = new Vec3(pos.x + velocity.x * dt, pos.y + velocity.y * dt, pos.z + velocity.z * dt);
  }
  
  private float cube(float x) { return x*x*x; }
}

float dt = 0.00032f;
float t = 0;

Sphere star;
Planet[] planet;

void setup()
{
  size(1280,720, P3D);
  frameRate(600);
  noStroke();
  
  planet = new Planet[10];
  
  star = new Sphere(new Vec3(width/2,height/2,-150), 100);
  
  planet[0] = new Planet(new Vec3(700,400,0), star, 50);
  planet[0].velocity = new Vec3(20000, -10000, 0);

  planet[1] = new Planet(new Vec3(600,400,0), star, 50);
  planet[1].velocity = new Vec3(-24000, 20, 0);
  
  planet[2] = new Planet(new Vec3(700,400,-300), star, 50);
  planet[2].velocity = new Vec3(20000, 12000, 0);
}

void draw()
{
  clear();
  background(200);
  println(frameRate);
  pushMatrix();
  
  planet[0].updatePos();
  planet[1].updatePos();
  planet[2].updatePos();
  
  star.draw(0,0,0);
  
  lights();
  planet[0].draw(255,0,0);
  planet[1].draw(0,255,0);
  planet[2].draw(0,0,255);
  
  popMatrix();
  t+=dt;
}
