import processing.sound.*;

PImage bg;
PImage img_zrni;
PShape trefoil;

PShape tree1, tree5, tree6, goat, cow, rat;

float tree1Speed, tree5Speed, tree6Speed, goatSpeed, cowSpeed, ratSpeed, boxSpeed;

float x;
float y;
float easing = 0.05;

// Declare the processing sound variables 
SoundFile sample;
SoundFile sample2;
Amplitude rms;

ParticleSystem ps;

// declare a drawing variable for calculating rect width
float r_width;

// Used for smoothing
float sum;

float volume;

void setup() {
  size(1152, 768, P3D);
  
  //bg = loadImage("assets/bg.jpg");
  img_zrni = loadImage("assets/skupina.jpg");
  
  tree1 = loadShape("assets/tree1.obj");
  tree5 = loadShape("assets/tree5.obj");
  tree5.scale(12);
  
  tree6 = loadShape("assets/tree6.obj");
  tree6.scale(42);
  
  goat = loadShape("assets/goat.obj");
  goat.scale(0.15);
  cow = loadShape("assets/cow.obj");
  cow.scale(0.3);
  cow.shininess(15.0);
  
  rat = loadShape("assets/rat.obj");
 
  //Load and play a soundfile and loop it
  sample = new SoundFile(this, "/Users/milan/Disk Google/Grafika/2018-01 Rozhlas podcast/processing/diagram1/assets/zrni.aif");
  //sample.loop();

  
  // Create and patch the rms tracker
  rms = new Amplitude(this);
  rms.input(sample);
 
  ps = new ParticleSystem(new PVector(width/2, height + 350));
}      

void draw() {
  // Set background color, noStroke and fill color
  //background(bg);
  background(10,10,10);
  noStroke();
  fill(255, 15, 15);
  
  volume = rms.analyze();
  
  ambient(250, 250, 250);
  pointLight(255, 160, 255, 0, 0, 200);
  pointLight(155, 155, 155, width + 400, height/2, 400);
  pointLight(155, 155, 155, 0, height + 300, -200);
  
  pushMatrix();
  translate(width/2, height/2);
  rotateX(boxSpeed);
  rotateY(-boxSpeed);
  rotateZ(boxSpeed);
  
  float dx = (volume*100) - x;
  x += dx * easing;
  box(x + 110);
  boxSpeed += 0.001;  
  popMatrix();
  
  pushMatrix();  
  translate(width/2, height/2);
  rotateZ(tree6Speed);
  rotateY(tree6Speed);
  rotateX(PI);
  translate(-100, 550);
  shape(tree6);
  tree6Speed += 0.0007;
  popMatrix();
  
  pushMatrix();  
  translate(width/2, height/2);
  rotateZ(PI);
  rotateY(tree1Speed);
  rotateX(tree1Speed);
  translate(400, 150);
  shape(tree1);
  tree1Speed += 0.0005;
  popMatrix();
  
  pushMatrix();  
  translate(0, height/2);
  
  rotateZ(-tree5Speed);
  //rotateY(tree5Speed);
  rotateX(PI);
  translate(width - 100, -300);
  shape(tree5);
  tree5Speed += 0.0001;
  popMatrix();
  
  pushMatrix();  
  translate(width/2, height/2, 0.5);
  rotateZ(goatSpeed);
  rotateY(-PI);
  rotateX(goatSpeed);
  translate(230, 430, 150);
  shape(goat);
  goatSpeed += 0.0004;
  popMatrix();
    
  pushMatrix();  
  translate(width/2 + 150, height/2, 0.5);
  rotateZ(PI);
  rotateY(ratSpeed);
  rotateX(ratSpeed);
  translate(130, 230, -150);
  shape(rat);
  ratSpeed += 0.0003;
  popMatrix();
  
  pushMatrix();
  ambient(color(0,0,255));
  translate(width/2 + 150, height/2, 0.5);
  rotateZ(PI/2);
  rotateY(cowSpeed);
  rotateX(cowSpeed);
  translate(530, 230, -450);
  shape(cow);
  cowSpeed += 0.0001;
  popMatrix();
  
  pushMatrix();
  translate(0,0,-500);
  ps.addParticle();
  ps.run();
  popMatrix();
  
}

boolean randomBool() {
  return random(1) > .5;
}