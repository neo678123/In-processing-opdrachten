class Vec2
{
  public float x, y;
  
  public Vec2(float x, float y)
  {
    this.x = x;
    this.y = y;
  }
  
  public float mag()
  {
    return sqrt(x*x+y*y); 
  }
  
  public float sqrmag()
  {
    return x*x+y*y; 
  }
  
  public float dot(Vec2 v)
  {
    return x*v.x+y*v.y; 
  }
}

Vec2[] triangle = {new Vec2(0,0), new Vec2(100,0), new Vec2(100, 100)};
Vec2[] rectangle = {new Vec2(150,150), new Vec2(150,250), new Vec2(250, 250), new Vec2(250,150)};

Vec2 circlePos = new Vec2(300,300);
float r = 50;

void setup()
{
  size(800,800);
}

void update()
{
  
}

void draw()
{
  update();
  
  fill(255,0,0);
  triangle(triangle[0].x, triangle[0].y, triangle[1].x, triangle[1].y, triangle[2].x, triangle[2].y); 
  
  fill(0,255,0);
  quad(rectangle[0].x, rectangle[0].y, rectangle[1].x, rectangle[1].y, rectangle[2].x, rectangle[2].y, rectangle[3].x, rectangle[3].y); 
  
  fill(0,0,255);
  ellipse(circlePos.x, circlePos.y, r, r);
}