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
   
   public void draw(int r, int g, int b)
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
  
  public void draw(int r, int g, int b)
  {
     fill(r,g,b);
     
     ellipseMode(CENTER);
     ellipse(pos.x, pos.y, 2*this.r, 2*this.r);
  }
}

class Ball extends Circle
{
  public Vec2 velo;
  public float acc = 1.001f;
  public boolean shouldReflect;
  
  public Ball(Vec2 pos, float r, Vec2 initVelo)
  {
    super(pos, r);
    this.velo = initVelo;
  }
  
  public void update(float dt)
  {
    this.velo = this.velo.mul(this.acc);
    if(shouldReflect)
    {
      this.velo = this.velo.reflect(new Vec2(-1,0).mul((velo.x) / (abs(velo.x))));
      shouldReflect = false;
    }
    if(pos.y + r >= height && velo.y > 0)
      this.velo = this.velo.reflect(new Vec2(0, -1));
    if(pos.y - r <= 0 && velo.y < 0)
      this.velo = this.velo.reflect(new Vec2(0, 1));
      
    this.pos = this.pos.add(velo.mul(dt));
  }
  
  public void checkReflect(Rectangle R)
  {
    Vec2[] vertices = R.getVertices();
    
    if(pos.y + r >= vertices[0].y && pos.y - r <= vertices[2].y)
    {
       if(pos.x + r >= vertices[0].x && pos.x - r <= vertices[2].x)
       {
          shouldReflect = true;
          if(velo.x > 0)
            pos.x = vertices[0].x - r;
          if(velo.x < 0)
            pos.x = vertices[2].x + r;
       }
    }
  }
}

class moveableRect extends Rectangle
{
  private Vec2 velo;
  
  public moveableRect(float x, float y, float w, float h)
  {
    super(x, y, w, h);
    velo = new Vec2(0,0);
  }
  
  public void setVelo(Vec2 v) { velo = v; }
  public Vec2 getVelo() { return velo; }
  
  public void update(float dt)
  {
    centre = centre.add(velo.mul(dt)); 
  }
}

boolean OOBleft(Ball b){ return b.pos.x - b.r < 0; }
boolean OOBright(Ball b){ return b.pos.x + b.r > width; }

Ball b;
int scoreL, scoreR;
moveableRect player1, player2;

void setup()
{
  size(1280, 720);
  b = new Ball(new Vec2(width/2,height/2), 20, new Vec2(random(-200, 200),random(-200, 200))); 
  
  player1 = new moveableRect(width/30, height/2, 30, height/4);
  player2 = new moveableRect(width-width/30, height/2, 30, height/4);
}

void draw()
{
  clear();
  
  text(scoreL + " - " + scoreR, 10, 20);
  
  b.checkReflect(player1);
  b.checkReflect(player2);
  b.update(1f/60f);
  b.draw(0xFF,0x00,0x00);
  
  player1.update(1f/60f);
  player1.draw(0x00,0xFF,0x00);
  
  player2.update(1f/60f);
  player2.draw(0x00,0xFF,0x00);
  
  if(OOBleft(b)){
    scoreR++;
    setup();
  }
  if(OOBright(b)) {
    scoreL++;
    setup();
  }
}

void keyPressed() 
{
  if(key == 's'){
     player1.velo.y = 600f;
  }
  if(key == 'w'){
    player1.velo.y = -600f;
  }
  
  if(key == 'r'){
    scoreL = scoreR = 0;
    setup();
  }
  
  if(key == CODED)
  {
     if(keyCode == UP)
       player2.velo.y = -600f;
     if(keyCode == DOWN)
       player2.velo.y = 600f;
  }
}

void keyReleased()
{
  if(key == 's'){
     player1.velo.y = 0;
  }
  if(key == 'w'){
     player1.velo.y = 0;
  }
  
  if(key == CODED)
  {
     if(keyCode == UP)
       player2.velo.y = 0f;
     if(keyCode == DOWN)
       player2.velo.y = 0f;
  }
}
