//<>// //<>// //<>// //<>// //<>// //<>//
import geomerative.RFont;
import geomerative.RShape;
import geomerative.RG;

import java.util.*;
import java.lang.*;
import java.io.*;

Engine_Ball_Bar engine;
int tick_rate = 1;
int framerate = 60;
void setup() {
  RG.init(this);
  size(1280, 720);
  delay(750);
  engine = new Engine_Ball_Bar(10, 50, 8);
  engine.set_dimensions(width, height);
  engine.reset_balls();
  background(0);
  frameRate(tick_rate * framerate);
}

int tick_iter = tick_rate;
void draw() {
  engine.update();
  tick_iter++;
  if (tick_iter % tick_rate == 0) { //We can set tick_rate to 2, and have it only render every second frame. 
    tick_iter = tick_rate;
    background(0);
    engine.draw();
  }
}
