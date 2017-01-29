int r, c;
int scale = 20;
int w = 2000;
int h = 1600;

float memes;
float[][] heightmap;

void setup()
{
   size(1280, 720, P3D);
   c = w / scale;
   r = h / scale;
   heightmap = new float[c][r];
   
   stroke(255);
   noFill();
}

void draw()
{
   clear();
   memes -= 0.1f;
   float _y = memes;
   
   for(int y = 0; y < r; y++)
   {
      float _x = 0; 
      for(int x = 0; x < c; x++)
      {
          heightmap[x][y] = map(sin(x)+cos(y), -2, 2, -100, 100);
          _x += 0.2f;
      }
      _y += 0.2f;
   }
   
   translate(width/2, height/2 + 50);
   rotateX(PI/3);
   translate(-w/2, -h/2);
   
   for(int y = 0; y < r-1; y++)
   {
      beginShape(TRIANGLE_STRIP);
      for(int x = 0; x < c; x++)
      {
         vertex(x*scale, y*scale, heightmap[x][y]);
         vertex(x*scale, (y+1)*scale, heightmap[x][y+1]);
      }
      endShape();
   }
}
