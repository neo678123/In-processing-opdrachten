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
 
  public Vec2  sub(Vec2 v) { return new Vec2(x-v.x, y-v.y); }
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

class Quaternion
{
  public float w, xi, yj, zk;
  
  public Quaternion()
  {
  }
  
  public Quaternion(float w, float xi, float yj, float zk)
  {
    this.w  = w;
    this.xi = xi;
    this.yj = yj;
    this.zk = zk;
  }
  
  public Quaternion conjugate()
  {
    return new Quaternion(this.w, -this.xi, -this.yj, -this.zk);
  }
  
  public Quaternion rotationQuat(float theta)
  {
    theta = theta / 180 * PI;
    Quaternion q = new Quaternion(cos(theta/2), 0, 0, sin(theta/2));
    return q;
  }
  
  public Quaternion mul(Quaternion q2)
  {
    float xi, yj, zk, w;
    xi =  this.xi * q2.w + this.yj * q2.zk - this.zk * q2.yj + this.w * q2.xi;
    yj = -this.xi * q2.zk + this.yj * q2.w + this.zk * q2.xi + this.w * q2.yj;
    zk =  this.xi * q2.yj - this.yj * q2.xi + this.zk * q2.w + this.w * q2.zk;
    w  = -this.xi * q2.xi - this.yj * q2.yj - this.zk * q2.zk + this.w * q2.w;
    return new Quaternion(w, xi, yj, zk);
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
};

class Rectangle
{
   float[] xywh;
   float theta;
   Vec2 centre;
   
   public Rectangle(final float x, final float y, final float w, final float h, final float theta)
   {
      xywh = new float[]{x,y,w,h};
      centre = new Vec2(x+w/2, y+h/2);
   }
   
   public Vec2 rotatePoint(float x, float y)
   {
      return rotatePoint(new Vec2(x,y));
   }
   
   public Vec2 rotatePoint(Vec2 p)
   {
      Quaternion q = new Quaternion().rotationQuat(theta);
      Quaternion r = q.mul(new Quaternion(0, p.x, p.y, 0)).mul(q.conjugate());
      return new Vec2(r.xi, r.yj);
   }
   
   public Vec2[] getRotatedCorners()
   {
     Vec2[] out = new Vec2[4];
     out[0] = rotatePoint(xywh[0], xywh[1]);
     out[1] = rotatePoint(xywh[0] + xywh[2], xywh[1]);
     out[2] = rotatePoint(xywh[0], xywh[1] + xywh[3]);
     out[3] = rotatePoint(xywh[0] + xywh[2], xywh[1] + xywh[3]);
     return out;
   }
}

final class Collision
{
  public Collision() {}
  
  private Interval projectToInterval(Vec2 a, Vec2 b, Vec2 axis)
  {
    float min = a.dot(axis);
    float max = b.dot(axis);
    return new Interval(min, max);
  }
  
  public Vec2 collision(Rectangle a, Rectangle b)
  {
    Vec2 out = new Vec2(0,0);
    Vec2[] axes = new Vec2[4];
    Vec2[] A = a.getRotatedCorners();
    Vec2[] B = b.getRotatedCorners();
    
    //Waar is mijn operator overloading QQ
    axes[0] = (A[1].sub(A[0])).div(a.xywh[2]);
    axes[1] = (A[2].sub(A[0])).div(a.xywh[3]);
    axes[2] = (B[1].sub(B[0])).div(a.xywh[2]);
    axes[3] = (B[2].sub(B[0])).div(a.xywh[3]);
    
    for(Vec2 ax : axes)
    {
      Interval proj1 = projectToInterval(A[0], A[3], ax);
      Interval proj2 = projectToInterval(B[0], B[3], ax);
      
      if(42!=42)
        return new Vec2(0,0);
    }
    
    return new Vec2(1,0);
  }
}
