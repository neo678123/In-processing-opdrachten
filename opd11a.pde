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
  
  public Vec2 normalized()
  {
    float m = mag();
    return new Vec2(x / m, y / m);
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
     stroke(red,green,blue);
     
     ellipseMode(CENTER);
     ellipse(pos.x, pos.y, 2*r, 2*r);
  }
  
  public Vec2 intersectionDepth(Circle c)
  {
     Vec2 diff = new Vec2(pos.x - c.pos.x, pos.y - c.pos.y);
     float L = diff.mag();
     
     if(L >= c.r + r)
       return new Vec2(0,0);
       
     Vec2 diffnorm = diff.normalized();
     return new Vec2((c.r + r - L) * diffnorm.x, (c.r + r - L) * diffnorm.y);
  }
}

float t;
long prev;
double dt = 0;

byte hv = 0; // horiz 0, vertic 1
Vec2 c2Velo;

Circle c1, c2;
Vec2 ds;

void setup()
{
  size(800,800);
  frameRate(60);
  t = 0;
  noFill();
  
  c1 = new Circle(new Vec2(400,500), 90);
  c2 = new Circle(new Vec2(300,460), 120);
  c2Velo = new Vec2(0,0);
  
  ds = c2.intersectionDepth(c1);
}

void update()
{
  t+=dt;
  dt = (-prev + (prev = frameRateLastNanos))/1e9d;
  
  c2.pos.x += c2Velo.x * dt;
  c2.pos.y += c2Velo.y * dt;
  
  ds = c2.intersectionDepth(c1);
  c2.pos.x += ds.x;
  c2.pos.y += ds.y;
  
  println(1/dt);
}

void draw()
{
  clear();
  background(50);
  pushMatrix();

  update();
  
  c1.draw(0,255,255);
  c2.draw(255,255,0);

  line(c1.pos.x, c1.pos.y, c1.pos.x+ds.x, c1.pos.y+ds.y);

  popMatrix();
}

void keyPressed() 
{
  if(key == 's'){
    c2Velo.y = 200f;
  }
  if(key == 'w'){
    c2Velo.y = -200f;
  }
  if(key == 'd'){
    c2Velo.x = 200;
  }
  if(key == 'a'){
    c2Velo.x = -200f;
  }
}

void keyReleased()
{
  if(key == 's'){
    c2Velo.y = 0;
  }
  if(key == 'w'){
    c2Velo.y = 0;
  }
  if(key == 'd'){
    c2Velo.x = 0;
  }
  if(key == 'a'){
    c2Velo.x = 0;
  }
}
