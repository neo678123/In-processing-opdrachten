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
}

class Interval 
{
  float min, max;
  public Interval(float min, float max)
  {
   this.min = min;
   this.max = max;
  }
  
  public boolean overlapsWith(Interval i2){  return !doNotOverlap(i2);}
  
  public float length() { return max - min; }
  
  public float computeOverlapWith(Interval i2) { return computeOverlap(i2); }
  
  public boolean contains(Interval i2) {  return min <= i2.min && i2.max <= max;}
  
  private boolean doNotOverlap(Interval i2) {
    return max <= i2.min || i2.max <= min;
  }
  private float computeOverlap(Interval i2) {
    
    if (doNotOverlap(i2))
      return 0.0f;
    
    if (contains(i2))
      return i2.length();
      
    if (i2.contains(this))
      return length();
      
    if (min < i2.min)
      return max - i2.min;
      
    return i2.max - min;
    
  }
}

class Rectangle
{
   public float[] xywh;
   public float theta;
   public Vec2 centre;
   
   public Rectangle(final float x, final float y, final float w, final float h, final float theta)
   {
      xywh = new float[]{x,y,w,h};
      this.theta = theta;
      centre = new Vec2(x+w/2, y+h/2);
   }

   public Vec2[] getVertices()
   {
      float cw = 0.5f * cos(theta) * xywh[2];
      float sh = 0.5f * sin(theta) * xywh[3];
      float ch = 0.5f * cos(theta) * xywh[3];
      float sw = 0.5f * sin(theta) * xywh[2];
      return new Vec2[] {  centre.add(new Vec2(sh-cw, -ch-sw)),         //Left top
                           centre.add(new Vec2(-sh - cw, ch - sw)),     //Left bottom
                           centre.add(new Vec2(-sh + cw, ch + sw)),     //Right bottom
                           centre.add(new Vec2(sh + cw, - ch + sw)) };  //Right top
   }
   
   public void translate(Vec2 v)
   {
     centre = centre.add(v);
     xywh[0] += v.x;
     xywh[1] += v.y;
   }
   
   public void draw()
   {
      Vec2[] c = getVertices();
      beginShape();
      vertex(c[0].x, c[0].y);
      vertex(c[1].x, c[1].y);
      vertex(c[2].x, c[2].y);
      vertex(c[3].x, c[3].y);
      endShape(CLOSE);
   }
}

final class Collision
{
  public Collision() {}
  
  private Interval projectToInterval(Rectangle a, Vec2 axis)
  {
      Vec2[] vertices = a.getVertices();
    
      float[] D = new float[4];
      for(int k = 0; k < 4; k++)
          D[k] = vertices[k].dot(axis);
    
      return new Interval(min(D), max(D));
  }
  
  public Vec2 collision(Rectangle a, Rectangle b)
  {
    Vec2 out = new Vec2(0,0);
    float overlap = 1E9;
    
    Vec2 smallestAxis = new Vec2(0,0);
    Vec2[] axes = new Vec2[4];
    
    Vec2[] A = a.getVertices();
    Vec2[] B = b.getVertices();
    
    //Waar is mijn operator overloading QQ
    axes[0] = (A[3].sub(A[0])).div(a.xywh[2]);
    axes[1] = (A[1].sub(A[0])).div(a.xywh[3]);
    axes[2] = (B[3].sub(B[0])).div(b.xywh[2]);
    axes[3] = (B[1].sub(B[0])).div(b.xywh[3]);
    
    for(Vec2 ax : axes)
    {
      Interval proj1 = projectToInterval(a, ax);
      Interval proj2 = projectToInterval(b, ax);
      
      if(proj1.overlapsWith(proj2))
      {
        float o = proj1.computeOverlapWith(proj2);
        if(o < overlap)
        {
          overlap = o;
          smallestAxis = ax;
        }
      } 
      else
        return new Vec2(0,0);
    }
    
    out = smallestAxis.mul(overlap);
    if( a.centre.sub(b.centre).dot(smallestAxis) < 0.0f)
      out = out.sub(out.mul(2));
      
    print(out.x + " " + out.y + "\n");
    return out;      
  }
  
  public void handleCollision(Rectangle a, Rectangle b) //<--- stiekem is dit pass by reference
  {
    Vec2 v = collision(a,b);
    
    if(v.sqrmag() > 0)
    {
      //ik veronderstel hier dat b stilstaat
      //a.translate(v.div(2));
      b.translate(new Vec2(0,0).sub(v));
    }
  }
}

Rectangle R1 = new Rectangle(100, 100, 100, 100, 45);
Rectangle R2 = new Rectangle(300, 400, 70, 150, 22);

Vec2 velo = new Vec2(0,0);
long prev;
double dt = 0;

Collision C = new Collision();

void setup()
{
  size(1280, 720);
}

void draw()
{
  dt = (-prev + (prev = frameRateLastNanos))/1e9d;  
  clear();
  
  R1.draw();
  R2.draw();
  
  C.handleCollision(R1, R2);
  R1.translate(velo.mul((float)dt));
  
  R1.theta+=0.01;
}

void keyPressed() 
{
  if(key == 's'){
    velo.y = 200f;
  }
  if(key == 'w'){
    velo.y = -200f;
  }
  if(key == 'd'){
    velo.x = 200;
  }
  if(key == 'a'){
    velo.x = -200f;
  }
}

void keyReleased()
{
  if(key == 's'){
    velo.y = 0;
  }
  if(key == 'w'){
    velo.y = 0;
  }
  if(key == 'd'){
    velo.x = 0;
  }
  if(key == 'a'){
    velo.x = 0;
  }
}
