/**
 * Processing Sound Library, Example 6
 * 
 * This sketch shows how to use the Amplitude class to analyze a
 * stream of sound. In this case a sample is analyzed. The smoothFactor
 * variable determines how much the signal will be smoothed on a scale
 * from 0 - 1.
 */

import processing.sound.*;

// Trig lookup tables borrowed from Toxi; cryptic but effective.
float sinLUT[];
float cosLUT[];
float SINCOS_PRECISION=1.0;
int SINCOS_LENGTH= int((360.0/SINCOS_PRECISION));
 
// System data
boolean dosave=false;
int num;
float pt[];
int style[];

// Declare the processing sound variables 
SoundFile sample;
SoundFile sample2;
Amplitude rms;
FFT fft;

// Declare a scaling factor
float scale = 7.0;

// Define how many FFT bands we want
int bands = 128;

// declare a drawing variable for calculating rect width
float r_width;

float[] sum2 = new float[bands];

// Declare a smooth factor
float smoothFactor = 0.01;

// Used for smoothing
float sum;

void setup() {
  size(1140, 660, P3D);

  r_width = width/float(bands);
 
  //Load and play a soundfile and loop it
  sample = new SoundFile(this, "/Users/milan/zrni.aif");
  sample.loop();
  
  sample2 = new SoundFile(this, "/Users/milan/zrni.aif");
  sample2.loop();
  
  // Create and patch the rms tracker
  rms = new Amplitude(this);
  rms.input(sample);
  
  fft = new FFT(this, bands);
  fft.input(sample2);
  
  // Fill the tables
  sinLUT=new float[SINCOS_LENGTH];
  cosLUT=new float[SINCOS_LENGTH];
  for (int i = 0; i < SINCOS_LENGTH; i++) {
    sinLUT[i]= (float)Math.sin(i*DEG_TO_RAD*SINCOS_PRECISION);
    cosLUT[i]= (float)Math.cos(i*DEG_TO_RAD*SINCOS_PRECISION);
  }
 
  num = 150;
  pt = new float[6*num]; // rotx, roty, deg, rad, w, speed
  style = new int[2*num]; // color, render style
 
  // Set up arc shapes
  int index=0;
  float prob;
  for (int i=0; i<num; i++) {
    pt[index++] = random(PI*2); // Random X axis rotation
    pt[index++] = random(PI*2); // Random Y axis rotation
 
    pt[index++] = random(60,80); // Short to quarter-circle arcs
    if(random(100)>90) pt[index]=(int)random(8,27)*10;
 
    pt[index++] = int(random(2,50)*5); // Radius. Space them out nicely
 
    pt[index++] = random(4,32); // Width of band
    if(random(100)>90) pt[index]=random(40,60); // Width of band
 
    pt[index++] = radians(random(5,30))/5; // Speed of rotation
    
    // get colors
    prob = random(100);
    if(prob<30) style[i*2]=colorBlended(random(1), 255,0,100, 255,0,0, 210);
    else if(prob<70) style[i*2]=colorBlended(random(1), 0,153,255, 170,225,255, 210);
    else if(prob<90) style[i*2]=colorBlended(random(1), 200,255,0, 150,255,0, 210);
    else style[i*2]=color(255,255,255, 220);

    if(prob<50) style[i*2]=colorBlended(random(1), 200,255,0, 50,120,0, 210);
    else if(prob<90) style[i*2]=colorBlended(random(1), 255,100,0, 255,255,0, 210);
    else style[i*2]=color(255,255,255, 220);

    style[i*2+1]=(int)(random(100))%3;
  }
}      

void draw() {
  // Set background color, noStroke and fill color
  background(0, 0, 0);
  noStroke();
  fill(0, 105, 165);
  
  drawElipse();
  
  // Smooth the rms data by smoothing factor
  sum += (rms.analyze() - sum) * smoothFactor;  

  // rms.analyze() return a value between 0 and 1. It's
  // scaled to height/2 and then multiplied by a scale factor
  float rmsScaled = sum * (height/2) * scale;

  // Draw an ellipse at a size based on the audio analysis
  ellipse(width/2, height/2, rmsScaled, rmsScaled);
  
  fft.analyze();
  for (int i = 0; i < bands; i++) {
    
    // smooth the FFT data by smoothing factor
   sum2[i] += (fft.spectrum[i] - sum2[i]) * smoothFactor;
    
    // draw the rects with a scale factor
    rect( i*r_width, height, r_width, -sum2[i]*height*scale );
  }
  
  int index=0;
  translate(width/2, height/2, 0);
  rotateX(PI/6);
  rotateY(PI/6);
 
  for (int i = 0; i < num; i++) {
    pushMatrix();
 
    rotateX(pt[index++]);
    rotateY(pt[index++]);
 
    if(style[i*2+1]==0) {
      stroke(style[i*2]);
      noFill();
      strokeWeight(1);
      arcLine(0,0, pt[index++],pt[index++],pt[index++]);
    }
    else if(style[i*2+1]==1) {
      fill(style[i*2]);
      noStroke();
      arcLineBars(0,0, pt[index++],pt[index++],pt[index++]);
    }
    else {
      fill(style[i*2]);
      noStroke();
      arc(0,0, pt[index++],pt[index++],pt[index++], rmsScaled);
    }
 
    // increase rotation
    pt[index-5]+=pt[index]/10;
    pt[index-4]+=pt[index++]/20;
 
    popMatrix();
  }
 
}

// Get blend of two colors
int colorBlended(float fract,
float r, float g, float b,
float r2, float g2, float b2, float a) {
 
  r2 = (r2 - r);
  g2 = (g2 - g);
  b2 = (b2 - b);
  return color(r + r2 * fract, g + g2 * fract, b + b2 * fract, a);
}
 
 
// Draw arc line
void arcLine(float x,float y,float deg,float rad,float w) {
  int a=(int)(min (deg/SINCOS_PRECISION,SINCOS_LENGTH-1));
  int numlines=(int)(w/2);
 
  for (int j=0; j<numlines; j++) {
    beginShape();
    for (int i=0; i<a; i++) { 
      vertex(cosLUT[i]*rad+x,sinLUT[i]*rad+y);
    }
    endShape();
    rad += 2;
  }
}
 
// Draw arc line with bars
void arcLineBars(float x,float y,float deg,float rad,float w) {
  int a = int((min (deg/SINCOS_PRECISION,SINCOS_LENGTH-1)));
  a /= 4;
 
  beginShape(QUADS);
  for (int i=0; i<a; i+=4) {
    vertex(cosLUT[i]*(rad)+x,sinLUT[i]*(rad)+y);
    vertex(cosLUT[i]*(rad+w)+x,sinLUT[i]*(rad+w)+y);
    vertex(cosLUT[i+2]*(rad+w)+x,sinLUT[i+2]*(rad+w)+y);
    vertex(cosLUT[i+2]*(rad)+x,sinLUT[i+2]*(rad)+y);
  }
  endShape();
}
 
// Draw solid arc
void arc(float x,float y,float deg,float rad,float w, float scale) {
  int a = int(min (deg/SINCOS_PRECISION,SINCOS_LENGTH-1));
  beginShape(QUAD_STRIP);
  for (int i = 0; i < a; i++) {
    vertex((cosLUT[i]*(rad)+x)*scale/100,(sinLUT[i]*(rad)+y));
    vertex(cosLUT[i]*(rad+w)+x,sinLUT[i]*(rad+w)+y);
  }
  endShape();
}

// Draw elipse by audio
void drawElipse() {

}