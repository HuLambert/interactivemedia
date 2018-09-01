 //<>// //<>// //<>//
import geomerative.RFont;
import geomerative.RShape;
import geomerative.RG;

import java.util.*;
import java.lang.*;
import java.io.*;

class sortByX implements Comparator<item> {
  public int compare(item a, item b) {
    return int(a.x - b.x);
  }
}


class item { 
  short x; 
  short y; 
  short deg; 
  byte vel_x; 
  byte vel_y; 
  byte vel_deg; 
  byte accel_x; 
  byte accel_y; 
  byte accel_deg;
}

void draw_all_items (String displaytext) {
  for (int i = 0; i < xyr.size(); i++) {
    fill(100);
    ellipse(xyr.get(i).x, xyr.get(i).y, 32, 32); 
    fill(255);
    textSize(32);
    textAlign(CENTER, CENTER);
    text(displaytext.charAt(i % displaytext.length()), xyr.get(i).x, xyr.get(i).y - 4);
    fill(100);
    /* Then Update */
  }
  for (int i = 0; i < bar_count; i++) {
    int x = width / (bar_count);
    rect(x * (i), height - bars[i], x, bars[i]);
  }
}

 //<>//

ArrayList<item> xyr = new ArrayList<item>();
int bar_count = 30; 
short[] bars = new short[bar_count];
short[] bar_vel = new short[bar_count];




void setup() {
  RG.init(this);
  size(640, 480);
  for (int i = 0; i < 5; i++) {
    xyr.add(new item());
    xyr.get(xyr.size() -1).x = (short)((i * 60) % width);
    xyr.get(xyr.size() -1).y = (short)(random(30, 0));
    xyr.get(xyr.size() -1).vel_x = (byte)(random(-10, 10));
  }
  background(0);
  frameRate(60);
}


void draw() {
  background(0);
  //update_bars();
  update_balls();
  balls_into_bounds();
  Collections.sort(xyr, new sortByX());
  ball_to_ball_collisions(16); 
  draw_all_items("HELLOWORLD");
  Collections.sort(xyr, new sortByX());
  //bar_to_ball_collisions();
  Collections.sort(xyr, new sortByX());
  
}
