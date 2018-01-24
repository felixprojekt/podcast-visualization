/**
 * Processing Sound Library, Example 6
 * 
 * This sketch shows how to use the Amplitude class to analyze a
 * stream of sound. In this case a sample is analyzed. The smoothFactor
 * variable determines how much the signal will be smoothed on a scale
 * from 0 - 1.
 */

import processing.sound.*;

//Trefoil
PGraphics pg;
PImage bg;
PImage img_zrni;
PShape trefoil;

// Declare the processing sound variables 
SoundFile sample;
SoundFile sample2;
Amplitude rms;
FFT fft;

ParticleSystem ps;
ParticleSystem ps2;

// Declare a scaling factor
float scale = 7.0;

// Define how many FFT bands we want
int bands = 128;

//Triangle dimensions
//float outsideRadius = 150;
//float insideRadius = 100;

// declare a drawing variable for calculating rect width
float r_width;

float[] sum2 = new float[bands];

// Declare a smooth factor
float smoothFactor = 0.01;

// Used for smoothing
float sum;

void setup() {
  size(1152, 768, P3D);
  bg = loadImage("/Users/milan/Disk Google/Grafika/2018-01 Rozhlas podcast/processing/bg.jpg");
  img_zrni = loadImage("/Users/milan/Disk Google/Grafika/2018-01 Rozhlas podcast/processing/skupina.jpg");
  
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
  
  r_width = width/float(bands);
 
  //Load and play a soundfile and loop it
  sample = new SoundFile(this, "/Users/milan/Disk Google/Grafika/2018-01 Rozhlas podcast/processing/zrni.aif");
  sample.loop();
  
  sample2 = new SoundFile(this, "/Users/milan/Disk Google/Grafika/2018-01 Rozhlas podcast/processing/zrni.aif");
  sample2.loop();
  
  // Create and patch the rms tracker
  rms = new Amplitude(this);
  rms.input(sample);
  
  fft = new FFT(this, bands);
  fft.input(sample2);
 
  ps = new ParticleSystem(new PVector(width/2, height - 150));
  
  //ps2 = new ParticleSystem(new PVector(width - width/4, height - 100));
  
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
  
  fft.analyze();
  for (int i = 0; i < bands; i++) {
    
    // smooth the FFT data by smoothing factor
   sum2[i] += (fft.spectrum[i] - sum2[i]) * smoothFactor;
    
    // draw the rects with a scale factor
    rect( i*r_width, height, r_width, -sum2[i]*height*scale );
  }
  
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
  
  /* 
  int numPoints = int(map(mouseX, 0, width, 6, 60));
  float angle = 0;
  float angleStep = 180.0/numPoints;
    
  beginShape(TRIANGLE_STRIP); 
  for (int i = 0; i <= numPoints; i++) {
    float px = width/2 + cos(radians(angle)) * outsideRadius;
    float py = height/2 + sin(radians(angle)) * outsideRadius;
    angle += angleStep;
    vertex(px, py);
    px = width/2 + cos(radians(angle)) * insideRadius;
    py = height/2 + sin(radians(angle)) * insideRadius;
    vertex(px, py); 
    angle += angleStep;
  }
  endShape();
  
  */

  
  //ps2.addParticle();
  //ps2.run();
 
}
 
// This function draws a trefoil knot surface as a triangle mesh derived
// from its parametric equation.
PShape createTrefoil(float s, int ny, int nx, PImage tex, float scale) {
  PVector p0, p1, p2;
  PVector n0, n1, n2;
  float u0, u1, v0, v1;
 
  PShape obj = createShape();
  obj.beginShape(TRIANGLES);
  obj.texture(tex);
  pg.fill(0, 0, 255, 200);
    
  for (int j = 0; j < nx; j++) {
    u0 = (float(j) / nx);
    u1 = (float(j + 1) / nx);
    for (int i = 0; i < ny; i++) {
      v0 = float(i) / ny;
      v1 = float(i + 1) / ny;
      
      p0 = evalPoint(u0, v0, scale);
      n0 = evalNormal(u0, v0, scale);
      
      p1 = evalPoint(u0, v1, scale);
      n1 = evalNormal(u0, v1, scale);
      
      p2 = evalPoint(u1, v1, scale);
      n2 = evalNormal(u1, v1, scale);

      // Triangle p0-p1-p2      
      obj.normal(n0.x, n0.y, n0.z);
      obj.vertex(s * p0.x, s * p0.y, s * p0.z, u0, v0);      
      obj.normal(n1.x, n1.y, n1.z);
      obj.vertex(s * p1.x, s * p1.y, s * p1.z, u0, v1);
      obj.normal(n2.x, n2.y, n2.z);
      obj.vertex(s * p2.x, s * p2.y, s * p2.z, u1, v1);

      p1 = evalPoint(u1, v0, scale);
      n1 = evalNormal(u1, v0, scale);

      // Triangle p0-p2-p1      
      obj.normal(n0.x, n0.y, n0.z);
      obj.vertex(s * p0.x, s * p0.y, s * p0.z, u0, v0);      
      obj.normal(n2.x, n2.y, n2.z);
      obj.vertex(s * p2.x, s * p2.y, s * p2.z, u1, v1);
      obj.normal(n1.x, n1.y, n1.z);
      obj.vertex(s * p1.x, s * p1.y, s * p1.z, u1, v0);      
    }
  }
  obj.endShape();
  return obj;
}

// Evaluates the surface normal corresponding to normalized 
// parameters (u, v)
PVector evalNormal(float u, float v, float scale) {
  // Compute the tangents and their cross product.
  PVector p = evalPoint(u, v, scale);
  PVector tangU = evalPoint(u + 0.01, v, scale);
  PVector tangV = evalPoint(u, v + 0.01, scale);
  tangU.sub(p);
  tangV.sub(p);
  
  PVector normUV = tangV.cross(tangU);
  normUV.normalize();
  return normUV;
}

// Evaluates the surface point corresponding to normalized 
// parameters (u, v)
PVector evalPoint(float u, float v, float scale) {
  float a = 1.5;
  float b = 0.3;
  float c = 0.5;
  float d = 0.3 + (scale/800);
  
  float s = TWO_PI * u;
  float t = (TWO_PI * (1 - v)) * 2;  
        
  float r = a + b * cos(1.5 * t);
  float x = r * cos(t);
  float y = r * sin(t);
  float z = c * sin(1.5 * t);
        
  PVector dv = new PVector();
  dv.x = -1.5 * b * sin(1.5 * t) * cos(t) -
         (a + b * cos(1.5 * t)) * sin(t);
  dv.y = -1.5 * b * sin(1.5 * t) * sin(t) +
         (a + b * cos(1.5 * t)) * cos(t);
  dv.z = 1.5 * c * cos(1.5 * t);
        
  PVector q = dv;      
  q.normalize();
  PVector qvn = new PVector(q.y, -q.x, 0);
  qvn.normalize();
  PVector ww = q.cross(qvn);
        
  PVector pt = new PVector();
  pt.x = x + d * (qvn.x * cos(s) + ww.x * sin(s));
  pt.y = y + d * (qvn.y * cos(s) + ww.y * sin(s));
  pt.z = z + d * ww.z * sin(s);
  return pt;
}

class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;

  ParticleSystem(PVector position) {
    origin = position.copy();
    particles = new ArrayList<Particle>();
  }

  void addParticle() {
    particles.add(new Particle(origin));
  }

  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
}


// A simple Particle class

class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  float opacity;

  Particle(PVector l) {
    if(randomBool()) {
      acceleration = new PVector(0.005, 0.002);
    } else {
      acceleration = new PVector(-0.005, -0.002);
    }
  
    velocity = new PVector(random(-0.5, 0.5), random(-1.5, 0));
    position = l.copy();
    lifespan = 555.0;
    opacity = 0;
  }

  void run() {
    update();
    display();
  }

  // Method to update position
  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    lifespan -= 1.0;
    opacity += 0.08;
    
  }

  // Method to display
  void display() {
    //stroke(255, lifespan);
    fill(255, 255, 255, opacity);
    ellipse(position.x, position.y, 6, 6);
  }

  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}

boolean randomBool() {
  return random(1) > .5;
}