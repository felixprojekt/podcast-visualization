class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  float opacity;

  Particle(PVector l) {
    if(randomBool()) {
      acceleration = new PVector(-0.00003, 0.00001);
    } else {
      acceleration = new PVector(0.00003, -0.00001);
    }
  
    velocity = new PVector(random(-1, 1), random(-1, 1));
    position = l.copy();
    lifespan = 1995.0;
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
    opacity += 0.00002;
    
  }

  // Method to display
  void display() {
    //stroke(255, lifespan);
    fill(255, 255, 255, opacity);
    ellipse(position.x, position.y, 12, 12);
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