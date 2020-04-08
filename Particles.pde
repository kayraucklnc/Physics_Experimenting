
import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

// A reference to our box2d world
Box2DProcessing box2d;

// A list we'll use to track fixed objects
ArrayList<Boundary> boundaries;
// A list for all of our rectangles
ArrayList<Box> boxes;


Windmill windmill;
Windmill windmill2;

void setup() {

  size(640, 720);
  smooth();

  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  // We are setting a custom gravity
  box2d.setGravity(0, -90);

  windmill = new Windmill(3*width/4, 600);
  windmill2 = new Windmill(width/4, 600);

  // Create ArrayLists  
  boxes = new ArrayList<Box>();
  boundaries = new ArrayList<Boundary>();

  // Add a bunch of fixed boundaries
  boundaries.add(new Boundary(width/2, height-5, width, 10));
  boundaries.add(new Boundary(width/2, 5, width, 10));
  boundaries.add(new Boundary(width-5, height/2, 10, height));
  boundaries.add(new Boundary(5, height/2, 10, height));
}

void draw() {
  background(40);
  textSize(12);
  text("Clicl \"L\" to toggle motors\nClick right mouse to attract\nClick left mouse to add particles\n\"X\" to reset", 20, 30);

  // We must always step through time!
  box2d.step();

  if ( mousePressed) {
    if (mouseButton == LEFT) {
      for (int i = 0; i<2; i++) {
        Box p = new Box(constrain(mouseX, 10, width-10), constrain(mouseY, 25, height-25));
        boxes.add(p);
      }
    }

    if (mouseButton == RIGHT) {
      for (Box b : boxes) {
        Vec2 pos = box2d.getBodyPixelCoord(b.body);

        PVector c = new PVector(pos.x, pos.y);
        PVector d = new PVector(constrain(mouseX, 0, width), constrain(mouseY, 0, height));

        PVector dir = PVector.sub(c, d);
        dir.normalize();
        dir.mult(1000);

        Vec2 wind = new Vec2(-dir.x, dir.y);
        b.applyForce(wind);
      }
    }
  }

  // Display all the boundaries
  for (Boundary wall : boundaries) {
    wall.display();
  }

  // Display all the boxes
  for (Box b : boxes) {
    b.display();
  }

  windmill.display();
  windmill2.display();

  // Boxes that leave the screen, we delete them
  // (note they have to be deleted from both the box2d world and our list
  for (int i = boxes.size()-1; i >= 0; i--) {
    Box b = boxes.get(i);
    if (b.done()) {
      boxes.remove(i);
      b.killBody();
    }
  }
}

void keyPressed() {
  if (key == 'l' || key == 'L') {
    windmill.toggleMotor();
    windmill2.toggleMotor();
  }
  if (key == 'x' || key == 'X') {
    for (int i = boxes.size()-1; i >=0; i--) {
      Box b = boxes.get(i);
      boxes.remove(i);
      b.killBody();
    }
  }
}
