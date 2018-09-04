//<>// //<>// //<>// //<>// //<>// //<>//
import geomerative.RFont;
import geomerative.RShape;
import geomerative.RG;

import java.util.*;
import java.lang.*;
import java.io.*;

Engine_Ball_Bar engine;

void setup() {
  RG.init(this);
  size(640, 480);
  delay(750);
  engine = new Engine_Ball_Bar(10, 10, 32);
  
  background(0);
  frameRate(30);
}

void draw() {
  background(0);
  engine.draw();

  engine.update();

  engine.move_balls_into_bounds();

  engine.handle_collisions();
}
