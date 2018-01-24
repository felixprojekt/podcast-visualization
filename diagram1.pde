import processing.sound.*;

//Trefoil
PGraphics pg;
PImage bg;
PImage img_zrni;
PShape trefoil;
PShape tree1;
PShape tree2;

float ry;

// Declare the processing sound variables 
SoundFile sample;
SoundFile sample2;
Amplitude rms;

ParticleSystem ps;

// Declare a scaling factor
float scale = 7.0;

//Triangle dimensions
//float outsideRadius = 150;
//float insideRadius = 100;

// declare a drawing variable for calculating rect width
float r_width;

// Declare a smooth factor
float smoothFactor = 0.01;

// Used for smoothing
float sum;

void setup() {
  size(1152, 768, P3D);
  bg = loadImage("assets/bg.jpg");
  img_zrni = loadImage("assets/skupina.jpg");
  
  tree1 = loadShape("assets/tree1.obj");
  tree2 = loadShape("assets/tree2.obj");
  
  //Trefoil
  textureMode(NORMAL);
  noStroke();
  // Creating offscreen surface for 3D rendering.
  pg = createGraphics(32, 512, P3D);
  pg.beginDraw();
  pg.noStroke();
  pg.endDraw(); 
  
  // Saving trefoil surface into a PShape3D object
  trefoil = createTrefoil(350, 60, 15, pg, scale);
 
  //Load and play a soundfile and loop it
  sample = new SoundFile(this, "/Users/milan/Disk Google/Grafika/2018-01 Rozhlas podcast/processing/zrni.aif");
  //sample.loop();

  
  // Create and patch the rms tracker
  rms = new Amplitude(this);
  rms.input(sample);
 
  ps = new ParticleSystem(new PVector(width/2, height - 150));
 
  
}      

void draw() {
  // Set background color, noStroke and fill color
  background(bg);
  noStroke();
  fill(255, 105, 165);

  
  // Smooth the rms data by smoothing factor
  sum += (rms.analyze() - sum) * smoothFactor;  

  // rms.analyze() return a value between 0 and 1. It's
  // scaled to height/2 and then multiplied by a scale factor
  float rmsScaled = sum * (height/2) * scale;

  // Saving trefoil surface into a PShape3D object
  trefoil = createTrefoil(150, 60, 15, img_zrni, rmsScaled);
  
  // Draw an ellipse at a size based on the audio analysis
  //ellipse(width/2, height/2, rmsScaled, rmsScaled);
  
  pg.beginDraw();    
  pg.ellipse(random(pg.width), random(pg.height), 150, 150);
  pg.endDraw(); 

  ambient(250, 250, 250);
  pointLight(255, 255, 255, 0, 0, 200);
  
  pushMatrix();
  translate(width/2, height/2, -200);
  rotateZ(frameCount * PI / 1000);
  rotateX(0);
  rotateY(0);      
  shape(trefoil);
  popMatrix();
  
  ps.addParticle();
  ps.run();
    
  pushMatrix();  
  translate(width/2, height/2);
  rotateZ(PI);
  rotateY(ry);
  rotateX(ry);
  translate(400, 150);
  shape(tree1);
  ry += 0.01;
  popMatrix();
  
  translate(width/2, height/2);
  //rotateZ(PI);
  //rotateY(ry);
  //rotateX(ry);
  translate(100, 250);
  shape(tree2);
  ry += 0.01;
  

}

boolean randomBool() {
  return random(1) > .5;
}