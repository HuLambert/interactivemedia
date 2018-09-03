class Bar_Manager { //<>//
  void update_bars () {
    for (int i = 0; i < bars_height.length; i++) {
      short rand = (short)(random(-5, 5));
      bars_previous_height[i] = bars_height[i];
      bars_height[i] = (short)(max(bars_height[i] + rand, 20));
    }
  }

  void draw() {
    fill(255, 0, 0, 255);

    for (int i = 0; i < bars_height.length; i++) {
      rect(get_bar_width() * (i), get_height(i), get_bar_width(), get_height(i));
    }
  }

  Ball[] bar_to_ball_collisions (Ball[] balls, int radius) {
    for (int i = 0; i < bar_count(); i++) {
      for (int j = 0; j < balls.length; j++) {
        Collision_Side col = ball_in_bar(balls[j], i, radius);
        if (col != Collision_Side.NONE) {
          balls[j] = handle_bar_to_ball_collision(balls[j], i, this, col, radius);
        }
      }
    }
    return balls;
  }

  int bar_count () 
  {
    return bars_height.length;
  }
  int get_height(int i) {
    return height - bars_height[i];
  }
  int get_height_previous(int i) {
    return height - bars_previous_height[i];
  }

  int get_bar_width() {
    return ceil(width / bars_height.length);
  }

  int get_bar_left(int i) {
    return get_bar_width() * i;
  }

  private int[] bars_height;
  private int[] bars_previous_height;


  Bar_Manager(int size) {
    bars_height = new int[size];
    bars_previous_height = new int[size];
    for (int i = 0; i < bars_height.length; i++) {
      bars_height[i] = 20;
    }
  }
  boolean point_in_bar (int x, int y, int bar) {
    if (x > get_bar_left(bar) && x < get_bar_left(bar + 1)) {
      if (y > get_height(bar)) {
        return true;
      }
    }
    return false;
  }

  // CIRCLE/RECTANGLE
  boolean circleRect(float cx, float cy, float radius, float rx, float ry, float rw, float rh) {

    // temporary variables to set edges for testing
    float testX = cx;
    float testY = cy;

    // which edge is closest?
    if (cx < rx)         testX = rx;      // test left edge
    else if (cx > rx+rw) testX = rx+rw;   // right edge
    if (cy < ry)         testY = ry;      // top edge
    else if (cy > ry+rh) testY = ry+rh;   // bottom edge

    // get distance from closest edges
    float distX = cx-testX;
    float distY = cy-testY;
    float distance = sqrt( (distX*distX) + (distY*distY) );

    // if the distance is less than the radius, collision!
    if (distance <= radius) {
      return true;
    }
    return false;
  }

  Collision_Side ball_in_bar (Ball ball, int bar, int radius) {
    if (circleRect(ball.x, ball.y, radius, get_bar_left(bar), get_height(bar), get_bar_width(), bars_height[bar])) {
      return  bar_to_ball_side(ball, get_height(bar), get_height_previous(bar), get_bar_left(bar), get_bar_left(bar + 1), radius);
    } else {
      return Collision_Side.NONE;
    }

    /*
    if (ball.get_left_of_ball(radius) < get_bar_width() * (bar + 1)) {
     if (ball.get_right_of_ball(radius) > get_bar_width() * (bar)) {
     if (ball.get_bottom_of_ball(radius) > get_height(bar)) {
     }
     }
     }
     
     
     
     {
     int corner_y = get_height(bar);
     int corner_x = get_bar_width() * bar;
     if (ball.x_old > get_bar_width() * (bar + 1)) {
     corner_x += get_bar_width();
     }
     if (point_in_bar(ball.x, ball.y, bar)) {
     return  bar_to_ball_side(ball, get_height(bar), get_height_previous(bar), get_bar_left(bar), get_bar_left(bar + 1), radius);
     }
     
     int corner_y = get_height(bar);
     int corner_x = get_bar_width() * bar;
     
     if (ball.x_old > get_bar_width() * (bar + 1)) {
     corner_x += get_bar_width();
     }
     
     float distX = ball.x - corner_x; 
     float distY = ball.y - corner_y; 
     float distance = sqrt((distX * distX) + (distY * distY));
     
     if (distance < radius) {
     return  bar_to_ball_side(ball, get_height(bar), get_height_previous(bar), get_bar_left(bar), get_bar_left(bar + 1), radius);
     }
     
     return Collision_Side.NONE;
     }
     */
  }

  Collision_Side ball_in_any_bar (Ball ball, int radius) {
    for (int i = 0; i < bars_height.length; i++) {
      Collision_Side col = ball_in_bar(ball, i, radius);
      if (col != Collision_Side.NONE) {
        return col;
      }
    }
    return  Collision_Side.NONE;
  }
}
