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

float t;
long prev;
double dt = 0;


void setup()
{
  size(800,800);
  frameRate(600);
  t = 0;
}

void update()
{
  t+=dt;
  dt = 0.00666;
}

Vec2 f(Vec2 v)
{
  return new Vec2(10f/cos(v.x/200), 10f/sin(v.y/100)); 
}

void draw()
{
  clear();
  pushMatrix();
  translate(width/2,height/2);
  scale(1,-1);
  
  update();
  stroke(255,255,255);
  line(0,height,0,-height);
  line(width,0,-width,0);
  
  stroke(255,0,0);
  for(float x = -width/2; x <= width; x+=10)
  {
      for(float y = -height/2; y <= height; y+=10)
      {
        Vec2 w = f(new Vec2(x,y));
        line(x, y, x+5*w.normalized().x, y+5*w.normalized().y);
        //line(x, y, x+w.x, y+w.y);
      }
  }
  
  popMatrix();
}
