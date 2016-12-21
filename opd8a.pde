float x, y, w, r;

void setup()
{
  size(1280,720, P3D);
  frameRate(60);
  noFill();
  stroke(255);
  
  String lines[] = loadStrings("dim.txt");
  for (int i = 0 ; i < lines.length; i++) 
    println(lines[i]);
    
  x = parseFloat(lines[1]);
  y = parseFloat(lines[2]);
  w = parseFloat(lines[3]);
  r = parseFloat(lines[4]);
}

void draw()
{
  clear();
  pushMatrix();

  translate(x,y,0);
  rotateY(r);
  box(w);
  
  popMatrix();
}
