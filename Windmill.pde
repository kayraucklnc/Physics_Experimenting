
class Windmill {

  // Our object is two boxes and one joint
  // Consider making the fixed box much smaller and not drawing it
  RevoluteJoint joint;
  Boxy box1;
  Boxy box2;
  float sclr = 1.2;

  Windmill(float x, float y) {

    // Initialize locations of two boxes
    box1 = new Boxy(x, y-20, 120*sclr, 10*sclr, false); 
    box2 = new Boxy(x, y, 10*sclr, 40*sclr, true); 


    // Define joint as between two bodies
    RevoluteJointDef rjd = new RevoluteJointDef();

    Vec2 offset = box2d.vectorPixelsToWorld(new Vec2(0, 60));

    rjd.initialize(box1.body, box2.body, box1.body.getWorldCenter());
    int scl = random(1)<0.5 ? -1 : 1;
    // Turning on a motor (optional)
    rjd.enableMotor = true;      // is it on?
    rjd.motorSpeed = scl*PI*4;       // how fast?
    rjd.maxMotorTorque = 9099990*sclr; // how powerful?


    // There are many other properties you can set for a Revolute joint
    // For example, you can limit its angle between a minimum and a maximum
    // See box2d manual for more

    // Create the joint
    joint = (RevoluteJoint) box2d.world.createJoint(rjd);
  }

  // Turn the motor on or off
  void toggleMotor() {
    joint.enableMotor(!joint.isMotorEnabled());
  }

  boolean motorOn() {
    return joint.isMotorEnabled();
  }


  void display() {
    //box2.display();
    box1.display();

    // Draw anchor just for debug
    Vec2 anchor = box2d.coordWorldToPixels(box1.body.getWorldCenter());
    fill(255, 0, 0);
    stroke(0);
    if (this.motorOn()) {
      fill(0, 255, 0);
    } else {
      fill(255, 0, 0);
    }
    ellipse(anchor.x, anchor.y, 7*sclr, 7*sclr);
  }
}
