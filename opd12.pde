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
}

class Rectangle
{
   public Vec2 centre;
   public float w, h;
   
   public Rectangle(float x, float y, float w, float h)
   {
     centre = new Vec2(x,y);
     this.w = w;
     this.h = h;
   }
   
   public Vec2[] getVertices()
   {
      float hw = 0.5f * w;
      float hh = 0.5f * h;
      return new Vec2[] {  centre.add(new Vec2(-hw, -hh)),         //Left top
                           centre.add(new Vec2(-hw,  hh)),     //Left bottom
                           centre.add(new Vec2( hw,  hh)),     //Right bottom
                           centre.add(new Vec2( hw, -hh)) };  //Right top
   }
   
   public Vec2 leftTop() { return centre.add(new Vec2(-0.5f * w, -0.5f * h)); }
   
   public void draw(byte r, byte g, byte b)
   {
     Vec2[] vertices = getVertices();  
     fill(r, g, b);
     
     beginShape();
     for(Vec2 v : vertices)
       vertex(v.x, v.y);
     endShape(CLOSE);
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
  
  public void draw(byte r, byte g, byte b)
  {
     fill(r,g,b);
     
     ellipseMode(CENTER);
     ellipse(pos.x, pos.y, 2*r, 2*r);
  }
}

class Ball extends Circle
{
  public Vec2 velo;
  public boolean shouldReflect;
  
  public Ball(Vec2 pos, float r, Vec2 initVelo)
  {
    super(pos, r);
    this.velo = initVelo;
  }
  
  public void update(float dt)
  {
    if(shouldReflect)
      this.velo = this.velo.reflect(new Vec2(-1,0).mul((pos.x - width/2) / (abs(pos.x - width/2))));
    this.pos = this.pos.add(velo.mul(dt));
  }
}
