/*
  Spiral Drawer
  ---------------
  This program uses stacked orbiting points to draw interesting spirals
  This is kind of like the code version of a spirograph
  
  written by Adrian Margel, Fall 2018
*/

//each Drawer is a rotating pen containing another Drawer at its tip
//basically this will draw an orbiting point but that point can recursively have more points orbitting it
class Drawer{
  //angle of the point being drawn
  float angle;
  //how fast the drawer rotates
  float spin;
  //the radius of the point's orbit
  float rad;
  //the child drawer orbitting this drawer's point
  Drawer child;
  int d;
  
  //simple consturctor
  Drawer(float a, float s, float r){
    angle=a;
    spin=s;
    rad=r;
  }
  
  //draw the point based on a set time (t) value relative to an anchor pos (ax,ay)
  void display(float t,float ax,float ay){
    //calculate the position of the point
    float x=cos(t*spin+angle)*rad+ax;
    float y=sin(t*spin+angle)*rad+ay;
    
    if(d%5==0||d%5==4){
      //draw the point
      colorMode(RGB);
      if(fade){
        //stroke(hue,255,255,255);
        drawPixel(color(100,30,5),(int)(x*zoom),(int)(y*zoom));
      }else{
        drawPixel(color(100,30,5),(int)(x*zoom),(int)(y*zoom));
        //stroke(hue,255,255,5);
      }
    }
    //point(x*zoom,y*zoom);
    
    //if the Drawer has a child draw the child using the point drawn as the new anchor pos
    if(child!=null){
      child.display(t,x,y);
    }
  }
  
  //generates children recursively to a set depth
  void generate(int deep){
    d=deep;
    if(deep>0){
      
      //----------SAFE TO MODIFY THIS CODE----------
      
      //the code here is arbitrary, it was discovered by playing around, feel free to change
      
      float spin=deep;
      float rad=(float)depth-deep;//(1000-deep);
      float angle=deep/(float)depth*TWO_PI;
      angle=PI/2;
      if(deep%5==2||deep%5==3){
        spin*=2.5;
        //angle=deep;
        //rad/=2;
      }
      if(deep%5==0){
        angle=deep/(float)depth*TWO_PI;
        spin*=3.25;
        //rad/=2;
      }
      //--------------------------------------------
      
      //create the child and attempt to generate grand-children
      child=new Drawer(angle,spin,rad);
      child.generate(deep-1);
    }
  }
}

//----------SAFE TO MODIFY THIS CODE----------

//how fast the drawers rotate
//float speed=0.00005;
float speed=0.000005;

//the current time being rendered
//this also acts as the start time
float time=1.6;
//float time=5.0;

//how much the drawers are scaled by
float zoom=0.05;

//the hue of the drawers
float hue=0;

//if the spiral slowly fades, this should be turned off for slow speeds
boolean fade=true;
//--------------------------------------------

//the depth the seed will generate to
int depth=4000;

//the seed/first drawer, acts as the parent of all other drawers
Drawer seed=new Drawer(0,0,0);
float[][] r;
float[][] g;
float[][] b;

void setup(){
  //set color mode to use hue
  colorMode(HSB);
  //set the size of the display
  size(800,800);
  r=new float[width][height];
  g=new float[width][height];
  b=new float[width][height];
  //set a black background
  //background(0);
  
  //set the framerate absurdly high to ensure it will always be maxed out
  frameRate(2000);
  //generate to the seed to the set depth
  seed.generate(depth);
}
void draw(){
  println(time);
  //draw a semi-transparent background
  if(fade){
    //fill(0,2);
    //noStroke();
    //rect(0,0,1200,800);
    fade();
  }
  
  //increase the time being rendered
  for(int i=0;i<50;i++){
  time+=speed;
  //display the spiral from the seed in the center of the screen
  seed.display(time,width/2/zoom,height/2/zoom);
  }
  
  drawScreen();
}
void fade(){
  for(int x=0;x<r.length;x++){
    for(int y=0;y<r[x].length;y++){
      //float loss=(r[x][y]+g[x][y]+b[x][y]);
      
      r[x][y]*=0.95;
      g[x][y]*=0.95;
      b[x][y]*=0.95;
    }
  }
}
void drawScreen(){
  colorMode(RGB);
  loadPixels();
  for(int x=0;x<r.length;x++){
    for(int y=0;y<r[x].length;y++){
      int red=(int)min(max(r[x][y],0),255);
      int green=(int)min(max(g[x][y],0),255);
      int blue=(int)min(max(b[x][y],0),255);
      pixels[x+y*width] = color(red,green,blue);
    }
  }
  updatePixels();
}
void drawPixel(color col,int x,int y){
  if(x<0||x>=r.length||y<0||y>=r[x].length)
    return;
  float red=red(col);
  float green=green(col);
  float blue=blue(col);
  
  r[x][y]+=red*0.15;
  g[x][y]+=green*0.15;
  b[x][y]+=blue*0.15;
}
