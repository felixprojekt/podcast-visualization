import processing.sound.*;

//Trefoil
PGraphics pg;
PImage bg;
PImage img_zrni;
PShape trefoil;

PShape tree1, tree4, goat, cow, rat;

float tree1Speed, tree4Speed, goatSpeed, cowSpeed, ratSpeed, boxSpeed;

float x;
float y;
float easing = 0.05;

// Declare the processing sound variables 
SoundFile sample;
SoundFile sample2;
Amplitude rms;

ParticleSystem ps;

// Declare a scaling factor
float scale = 7.0;

// declare a drawing variable for calculating rect width
float r_width;

// Used for smoothing
float sum;

float volume;

void setup() {
  size(1152, 768, P3D);
  
  bg = loadImage("assets/bg.jpg");
  img_zrni = loadImage("assets/skupina.jpg");
  
  tree1 = loadShape("assets/tree1.obj");
  tree4 = loadShape("assets/tree4.obj");
  tree4.scale(12);
  
  goat = loadShape("assets/goat.obj");
  goat.scale(0.15);
  cow = loadShape("assets/cow.obj");
  cow.scale(0.3);
  
  rat = loadShape("assets/rat.obj");
 
  //Load and play a soundfile and loop it
  sample = new SoundFile(this, "/Users/milan/Disk Google/Grafika/2018-01 Rozhlas podcast/processing/diagram1/assets/zrni.aif");
  sample.loop();

  
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
  
  volume = rms.analyze();
  
  ambient(250, 250, 250);
  pointLight(255, 255, 255, 0, 0, 200);
  
  pushMatrix();
  translate(width/2, height/2);
  rotateX(boxSpeed);
  rotateY(-boxSpeed);
  rotateZ(boxSpeed);
  
  float dx = (volume*100) - x;
  x += dx * easing;
  box(x + 160);
  boxSpeed += 0.003;  
  popMatrix();
  
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
  rotateY(tree1Speed);
  rotateX(tree1Speed);
  translate(400, 150);
  shape(tree1);
  tree1Speed += 0.01;
  popMatrix();
  
  pushMatrix();  
  translate(0, height/2);
  rotateZ(-tree4Speed);
  //rotateY(tree4Speed);
  rotateX(PI);
  translate(width - 100, -300);
  shape(tree4);
  tree4Speed += 0.001;
  popMatrix();
  
  pushMatrix();  
  translate(width/2, height/2, 0.5);
  rotateZ(goatSpeed);
  rotateY(-PI);
  rotateX(goatSpeed);
  translate(230, 430, 150);
  shape(goat);
  goatSpeed += 0.004;
  popMatrix();
    
  pushMatrix();  
  translate(width/2 + 150, height/2, 0.5);
  rotateZ(PI);
  rotateY(ratSpeed);
  rotateX(ratSpeed);
  translate(130, 230, -150);
  shape(rat);
  ratSpeed += 0.003;
  popMatrix();

  pushMatrix();  
  translate(width/2 + 150, height/2, 0.5);
  rotateZ(PI/2);
  rotateY(cowSpeed);
  rotateX(cowSpeed);
  translate(530, 230, -450);
  shape(cow);
  cowSpeed += 0.001;
  popMatrix();
  
}

boolean randomBool() {
  return random(1) > .5;
}