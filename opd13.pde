float w;
float h;

float offx, offy;

void setup()
{
  size(1280, 720);  
    
  w = 4;
  h = (w * height) / width;
  background(255);
  drawMandel();

  offx = offy = 0;
}

void draw()
{
   w = w; 
}



void drawMandel()
{

loadPixels();


// Start at negative half the width and height
float xmin = -w/2 + offx;
float ymin = -h/2 + offy;

int maxiterations = 100;

// x goes from xmin to xmax
float xmax = xmin + w;
// y goes from ymin to ymax
float ymax = ymin + h;

// Calculate amount we increment x,y for each pixel
float dx = (xmax - xmin) / (width);
float dy = (ymax - ymin) / (height);

// Start y
float y = ymin;
for (int j = 0; j < height; j++) {
  // Start x
  float x = xmin;
  for (int i = 0; i < width; i++) {

    // Now we test, as we iterate z = z^2 + cm does z tend towards infinity?
    float a = x;
    float b = y;
    int n = 0;
    while (n < maxiterations) {
      float aa = a * a;
      float bb = b * b;
      float twoab = 2.0 * a * b;
      a = aa - bb + x;
      b = twoab + y;
      // Infinty in our finite world is simple, let's just consider it 16
      if (dist(aa, bb, 0, 0) > 4.0) {
        break;  // Bail
      }
      n++;
    }

    // We color each pixel based on how long it takes to get to infinity
    // If we never got there, let's pick the color black
    if (n == maxiterations) {
      pixels[i+j*width] = color(0);
    } else {
      // Gosh, we could make fancy colors here if we wanted
      float norm = map(n, 0, maxiterations, 0, 1);
      pixels[i+j*width] = color(map(sqrt(norm), 0, 1, 0, 255));
    }
    x += dx;
  }
  y += dy;
}

updatePixels();
//pixels[i+j*width] = color(map(sqrt(norm), 0, 1, 0, 255)); 
}

void keyPressed() 
{
  if(key == '+'){
    clear();
    w-=0.1f;
    h = (w * height) / width;
    drawMandel();
  }
  
  if(key == '-'){
    clear();
    w+=0.1f;
    h = (w * height) / width;
    drawMandel();
  }
  
  if(key == 'a'){
    clear();
    offx-=0.01f;
    drawMandel();
  }
  
  if(key == 'd'){
    clear();
    offx+=0.01f;
    drawMandel();
  }
  
  
  if(key == 'w'){
    clear();
    offy-=0.01f;
    drawMandel();
  }
  
  if(key == 's'){
    clear();
    offy+=0.01f;
    drawMandel();
  }

}
