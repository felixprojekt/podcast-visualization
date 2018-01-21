/**
 * Processing Sound Library, Example 6
 * 
 * This sketch shows how to use the Amplitude class to analyze a
 * stream of sound. In this case a sample is analyzed. The smoothFactor
 * variable determines how much the signal will be smoothed on a scale
 * from 0 - 1.
 */

import processing.sound.*;

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
float smoothFactor = 0.04;

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
  
}      

void draw() {
  // Set background color, noStroke and fill color
  background(0, 0, 0);
  noStroke();
  fill(0, 105, 165);

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
 
}