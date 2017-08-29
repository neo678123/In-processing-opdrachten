public class Vec2
{
  public float x, y;
 
  public Vec2(float x, float y)
  {
    this.x = x;
    this.y = y;
  }
 
  public float sqrmag() { return x*x+y*y;}
  public float mag() { return sqrt(sqrmag()); }
 
  public Vec2  add(Vec2 v) { return new Vec2(x+v.x, y+v.y); }
  public Vec2  sub(Vec2 v) { return new Vec2(x-v.x, y-v.y); }
  public Vec2  mul(float s){ return new Vec2(x*s, y*s); }
  public Vec2  div(float s){ return new Vec2(x/s, y/s); }
  
  public float dot(Vec2 v) { return x*v.x+y*v.y; }
  public float distance(Vec2 v)
  {
    Vec2 u = new Vec2(x-v.x, y-v.y);
    return u.mag();
  }
  
  public Vec2 normalized()
  {
    float m = mag();
    return new Vec2(x / m, y / m);
  }
  
  public Vec2 reflect(Vec2 normal)
  {
    return this.sub(normal.mul(2 * this.dot(normal)));
  }
  
  public Vec2 transform(float m11, float m12, float m21, float m22)
  {
     return new Vec2(m11*x + m12*y, m21*x + m22*y); 
  }
}

class Circle
{
  Vec2 pos;
  float r;
  
  public Circle(Vec2 pos, float r)
  {
    this.pos = pos;
    this.r = r;
  }
  
  public void draw(int red, int green, int blue)
  {
     fill(red,green,blue);
     ellipse(pos.x, pos.y, r, r);
  }
}

//Het moment waar ik pointers mis q_q
class Planet extends Circle
{
  final float k = 20000f;
  float thisR, starR[];
  Vec2 starPos[], velocity, acceleration;
  
  public Planet(Vec2 pos, float r, Circle... star)
  {
    super(pos,r);
    thisR = r;
    
    starPos = new Vec2 [star.length];
    starR   = new float[star.length];
    
    int j = 0;
    for(Circle c : star) 
    {
      starR[j] = c.r;
      starPos[j] = c.pos;
      j++;
    }
    velocity = acceleration = new Vec2(0,0);
  }
  
  public void updatePos(float dt)
  {
     acceleration = new Vec2(0,0);
    
     for(Vec2 sp : starPos)
     {
       float C = k / cube(pos.distance(sp));
       Vec2 r = new Vec2(sp.x - pos.x, sp.y - pos.y);
       dt *= 2;
       acceleration = acceleration.add(new Vec2(C * r.x, C * r.y));
     }
     
     velocity = new Vec2(velocity.x + acceleration.x * dt, velocity.y + acceleration.y * dt);
     pos = new Vec2(pos.x + velocity.x * dt, pos.y + velocity.y * dt);
  }
  
  private float cube(float x) { return x*x*x; }
}

float t;
long prev;
double dt = 0;

Circle star[];
Planet planet[];

void setup()
{
  size(800,800);
  frameRate(6000);
  t = 0;
  planet = new Planet[10];
  star = new Circle[2];
  
  star[0] = new Circle(new Vec2(200,400), 100);
  star[1] = new Circle(new Vec2(600,400), 100);
  
  planet[0] = new Planet(new Vec2(200,600), 50, star);
  planet[1] = new Planet(new Vec2(100,600), 50, star);
  
  planet[0].velocity.x = 8;
  planet[1].velocity.x = -8;
}

void update()
{
  t+=dt;
  dt = 0.00666;
  //dt = (-prev + (prev = frameRateLastNanos))/1e9d;
  println(dt);
  
  planet[0].updatePos((float)dt);
  planet[1].updatePos((float)dt);
}

void draw()
{
  clear();
  background(200);
  pushMatrix();

  star[0].draw(0,255,255);
  star[1].draw(0,255,255);
  planet[0].draw(255,0,0);
  planet[1].draw(0,255,0);
  update();

  popMatrix();
}
