class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  float opacity;

  Particle(PVector l) {
    if(randomBool()) {
      acceleration = new PVector(-0.005, 0.002);
    } else {
      acceleration = new PVector(0.005, -0.002);
    }
  
    velocity = new PVector(random(-0.5, 0.5), random(-1.5, 0));
    position = l.copy();
    lifespan = 555.0;
    opacity = 10;
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
    opacity += 0.02;
    
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