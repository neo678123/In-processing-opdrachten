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

int lim;
int j; //j is welke plek
int swaps;
int comparisons;

int[] staven = {209, 451, 41, 331, 383, 257, 141, 89, 434, 165, 94, 32, 345, 315, 484, 25, 296, 311, 429, 160, 392, 58, 287, 199, 188, 464, 444, 452, 13, 489, 3, 70, 385, 225, 286, 172, 326, 197, 266, 218, 110, 242, 221, 396, 184, 126, 99, 281, 69, 276, 159, 401, 36, 96, 293, 313, 167, 327, 376, 472, 124, 284, 7, 347, 294, 337, 427, 196, 65, 495, 378, 267, 256, 27, 62, 443, 320, 475, 459, 121, 135, 83, 458, 161, 493, 418, 457, 388, 333, 357, 118, 483, 149, 71, 302, 122, 403, 85, 132, 30, 68, 424, 28, 24, 150, 86, 343, 314, 100, 191, 20, 237, 156, 348, 192, 332, 423, 361, 155, 428, 468, 289, 440, 127, 116, 203, 339, 240};

int max, count;
long lastTime;

void setup()
{
  size(1280,720);
  max = max(staven);
  count = staven.length;
  lastTime = millis();
  lim = count - 1;
  swaps = 0;
  comparisons = 0;
}

void draw()
{
  if (!sorted(staven)){
  staven = bubbleSortIteration(staven);
  clear();
  pushMatrix();
  
  //Transformeer naar wiskundig assenstelsel
  translate(0, 720);
  scale(1,-1);
  
  for(int k = 0; k < count; k++)
  {
    if (k == j){
      fill(255, 0, 0);
      rect(1280.0f/count * k, 0, 1280.0f/count, staven[k] * 720.0f/max);
    }else{
      fill(255, 255, 255);
      rect(1280.0f/count * k, 0, 1280.0f/count, staven[k] * 720.0f/max);
    }
  }
  
  fill(255, 255, 255);
  popMatrix();
  
  pushMatrix();
  
  translate(0, 0);
  scale(1, 1);
  text("Swaps: " + swaps, 10, 20);
  text("Comparisons: " + comparisons, 10, 30);
  
  popMatrix();
  }
}


public int[] bubbleSortIteration(int[] l){
  while (j <= lim){
    if (j == lim){
      j = 0;
      --lim;
    }
    
    if (l[j] > l[j + 1]){
       int p = l[j];
       l[j] = l[j + 1];
       l[j + 1] = p;
       swaps++;
       return l;
    }
    comparisons ++;
    j++;
  }
  return l;
}

boolean sorted(int[] l){
  for (int q = 0; q < l.length - 1; q++) if (l[q] > l[q+1]) return false; 
  return true;
}
