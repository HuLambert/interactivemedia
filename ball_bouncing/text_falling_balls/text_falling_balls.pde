//<>// //<>// //<>// //<>// //<>// //<>//
import geomerative.RFont;
import geomerative.RShape;
import geomerative.RG;

import java.util.*;
import java.lang.*;
import java.io.*;

Engine_Ball_Bar[] engine = new Engine_Ball_Bar[3];
int tick_rate = 1;
int framerate = 60;
void setup() {
  RG.init(this);
  size(1280, 720, P3D);
  delay(750);
  engine[0] = new Engine_Ball_Bar(new Ball_Manager(5, 8), new Bar_Manager(10), 360, 480);
  engine[1] = new Engine_Ball_Bar(new Ball_Manager(5, 8), new Bar_Manager(10), 360, 480);
  engine[2] = new Engine_Ball_Bar(new Ball_Manager(5, 8), new Bar_Manager(10), 360, 480);
  background(0);
  frameRate(tick_rate * framerate);
}


int tick_iter = tick_rate;


void draw() {
  background(0);
  for (int i = 0; i < engine.length; i ++ ) {
    engine[i].update();
  }
  tick_iter++;
  if (tick_iter % tick_rate == 0) { //We can set tick_rate to 2, and have it only render every second frame. 
    tick_iter = tick_rate;

    translate((width/2) - (engine[0].screen_width/2), (height/2) - (engine[0].screen_height/2));
    image(engine[0].draw(), 0, 0 );//draw
    translate(engine[0].screen_width, 0);
    rotateY(-PI / 3);
    image(engine[1].draw(), 0, 0);
    rotateY(PI / 3);
    translate(-engine[0].screen_width, 0);
    //translate(-pg.width, 0);
    rotateY(PI / 3);
    image(engine[2].draw(), -engine[0].screen_width, 0);
    //image(pg, - (pg.width /2), - (pg.height/2));
  }
}
