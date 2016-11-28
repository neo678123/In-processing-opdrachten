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

char subOpdracht = 'a';

Vec2[] rectangle = {new Vec2(0,0), new Vec2(0,100), new Vec2(100, 100), new Vec2(100,0)};
float x, y, t;
float oldMouseX, oldMouseY;
long prev;
double dt = 0;

void setup()
{
  size(800,800);
  frameRate(60);
  t = y = x = 0;
}

void update()
{
  t+=dt;
  dt = (-prev + (prev = frameRateLastNanos))/1e6d;
  
  //   2A
  if(subOpdracht == 'a')
  {
    x = 350*cos(t/1000) + 350;
    y = 350*sin(t/1000) + 350;
  }
  
  //   2B
  else
  {
    if(mousePressed)
    {
      if(mouseX < x + rectangle[2].x && mouseX > x)
      {
        if(mouseY < y + rectangle[2].y && mouseY > y)
        {
          x -= oldMouseX - mouseX;
          y -= oldMouseY - mouseY;
        }
      }
    }
    oldMouseX = mouseX;
    oldMouseY = mouseY;
  }
}

void draw()
{
  clear();
  
  
  pushMatrix();
  translate(x+50, y+50);
  rotate(t/400);
  translate(-50, -50);
  update();

  fill(255,0,0);
  quad(rectangle[0].x, rectangle[0].y, rectangle[1].x, rectangle[1].y, rectangle[2].x, rectangle[2].y, rectangle[3].x, rectangle[3].y); 
  
  popMatrix();
}