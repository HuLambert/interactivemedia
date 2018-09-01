//<>// //<>// //<>// //<>//
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

  short x_old; 
  short y_old; 

  short deg; 
  byte vel_x; 
  byte vel_y; 
  byte vel_deg; 
  byte accel_x; 
  byte accel_y; 
  byte accel_deg;
  boolean frozen = false;
  String toString() {
    return 
      x + " " + 
      y + " " + 
      vel_x + " " + 
      vel_y + " " +
      frozen + " ";
  }
}

void draw_all_items (String displaytext, int radius, ArrayList<item> balls) {
  
  for (int i = 0; i < bar_count; i++) {
    int x = ceil(width / bar_count);
    fill(255, 0, 0, 100);
    rect(x * (i), height - bars[i], x, bars[i]);
    fill(0, 0, 255, 100);
    rect(x * (i), height - (bars[i] - bar_vel[i]), x, bars[i] - bar_vel[i]);
    
  }
  for (int i = 0; i < balls.size(); i++) {
    
    textSize(radius * 1.5);

    //text(balls.get(i).toString(), balls.get(i).x, balls.get(i).y - (2 * radius));
    fill(255, 255, 255, 100);
    ellipse(balls.get(i).x, balls.get(i).y, radius * 2, radius * 2); 
    fill(0, 255, 255, 100);
    ellipse(balls.get(i).x_old, balls.get(i).y_old, radius * 2, radius * 2); 
    fill(255, 255, 255, 255);
    textSize(radius * 2);
    textAlign(CENTER, CENTER);
    text(displaytext.charAt(i % displaytext.length()), balls.get(i).x, balls.get(i).y - 4);

    /* Then Update */
  }
}



ArrayList<item> xyr = new ArrayList<item>();
int bar_count = 30; 
short[] bars = new short[bar_count];
short[] bar_vel = new short[bar_count];




void setup() {
  RG.init(this);
  size(1920, 480);
  for (int i = 0; i < 30; i++) {
    xyr.add(new item());
    xyr.get(xyr.size() -1).x = (short)((i * 60) % width);
    xyr.get(xyr.size() -1).y = (short)(random(400, 300));
    xyr.get(xyr.size() -1).vel_x = (byte)(random(-30, 30));
  }
  background(0);
  frameRate(30);
}

int framecount = 0;
boolean flag = false;
void draw() {
  if (flag) {
    flag = false;
  }
  background(0);
  framecount++; 
  if (framecount % 10 == 0) {
    background(0);
  }
  int radius = 8;
  draw_all_items("0123456789", radius, xyr);


  for (int i = 0; i < xyr.size(); i++) {
    xyr.get(i).x_old = xyr.get(i).x;
    xyr.get(i).y_old = xyr.get(i).y;
  }

  update_balls(); //Must be done before collisions between balls
  update_bars();
  balls_into_bounds(radius);
  Collections.sort(xyr, new sortByX());
  bar_to_ball_collisions(radius);
  Collections.sort(xyr, new sortByX());
  //ball_to_ball_collisions(radius); 
  Collections.sort(xyr, new sortByX());
  //draw_all_items("0123456789", radius, xyr);
}
