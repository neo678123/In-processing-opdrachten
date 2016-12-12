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

final float dx = 0.1;

float f(float x)
{
  return 300*sin(x/100); 
}

void setup()
{
  size(1280,720);
}

void draw()
{
  //clear();
  pushMatrix();
  
  text("(0,0)",width/2 - 30, height/2 + 10);
  text("(0,360)",width/2 - 40, 10);
  text("(0,-360)",width/2 - 40, height - 10);
  text("(640,0)",width - 40, height/2 + 10);
  text("(-640,0)",10, height/2 + 10);
  
  //Transformeer naar wiskundig assenstelsel
  translate(width/2, height/2);
  scale(1,-1);
  
  line(0,height,0,-height);
  line(width,0,-width,0);
  
  float prevX = -width;
  for(float x = -width/2; x < width/2; x+=dx)
  {
    line(prevX, f(prevX), x, f(x));
    prevX = x;
  }
  
  popMatrix();
}