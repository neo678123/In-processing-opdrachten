class Vec2
{
  public float x, y;
 
  public Vec2(float x, float y)
  {
    this.x = x;
    this.y = y;
  }
 
  public float sqrmag() { return x*x+y*y;}
  public float mag() { return sqrt(sqrmag()); }
 
  public float dot(Vec2 v) { return x*v.x+y*v.y; }
  public float distance(Vec2 v)
  {
    Vec2 u = new Vec2(x-v.x, y-v.y);
    return u.mag();
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
  float thisR, starR;
  Vec2 starPos, velocity, acceleration;
  
  public Planet(Vec2 pos, Circle star, float r)
  {
    super(pos,r);
    thisR = r;
    starR = star.r;
    
    starPos = star.pos;
    
    velocity = acceleration = new Vec2(0,8);
  }
  
  public void updatePos(float dt)
  {
     float C = k / cube(pos.distance(starPos));
     Vec2 r = new Vec2(starPos.x - pos.x, starPos.y - pos.y);
     dt *= 10;
     
     acceleration = new Vec2(C * r.x, C * r.y);
     velocity = new Vec2(velocity.x + acceleration.x * dt, velocity.y + acceleration.y * dt);
     pos = new Vec2(pos.x + velocity.x * dt, pos.y + velocity.y * dt);
  }
  
  private float cube(float x) { return x*x*x; }
}

float t;
long prev;
double dt = 0;

Circle star;
Planet planet;

void setup()
{
  size(800,800);
  frameRate(600);
  t = 0;
  
  star = new Circle(new Vec2(400,400), 100);
  planet = new Planet(new Vec2(200,400), star, 50);
}

void update()
{
  t+=dt;
  dt = 0.00666;
  //dt = (-prev + (prev = frameRateLastNanos))/1e9d;
  println(dt);
  
  planet.updatePos((float)dt);
}

void draw()
{
  clear();
  pushMatrix();

  star.draw(0,255,255);
  planet.draw(0,255,0);
  update();

  popMatrix();
}
