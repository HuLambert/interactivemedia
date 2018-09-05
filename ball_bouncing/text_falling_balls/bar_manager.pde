class Bar_Manager { //<>//
  void update_bars () {
    for (int i = 0; i < bars_height.length; i++) {
      short rand = (short)(random(-10, 10));
      bars_previous_height[i] = bars_height[i];
      bars_height[i] = (short)(max(bars_height[i] + rand, 20));
    }
  }
  int screen_width = 360;
  int screen_height = 480;
  
  void set_dimensions(int screen_width, int screen_height) {
    this.screen_width = screen_width;
    this.screen_height = screen_height;
  }

  PGraphics draw(PGraphics pg, color[] bar_color) {
    fill(255, 0, 0, 255);
    for (int i = 0; i < bars_height.length; i++) {
      pg.fill(bar_color[i % bar_color.length]);
      pg.rect(get_bar_width() * (i), get_height(i), get_bar_width(), bars_height[i]);
    }
    return pg;
  }

  

  int bar_count () 
  {
    return bars_height.length;
  }
  int get_height(int i) {
    return screen_height - bars_height[i];
  }
  int get_height_previous(int i) {
    return screen_height - bars_previous_height[i];
  }

  int get_bar_width() {
    return ceil(screen_width / bars_height.length);
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

  //Derived from jeffreythompson who derived it from Matt Worden 
  //http://www.jeffreythompson.org/collision-detection/circle-rect.php 
  boolean circleRect(Ball ball, float radius, int iter) {

    // temporary variables to set edges for testing
    float corner_X = ball.x;
    float corner_Y = ball.y;

    // which edge is closest?
    if (ball.x < get_bar_left(iter)) {         
      corner_X = get_bar_left(iter);
    }// test left edge
    else if (ball.x > get_bar_left(iter)+get_bar_width()) {
      corner_X = get_bar_left(iter) + get_bar_width();
    } // right edge
    if (ball.y < get_height(iter)) {         
      corner_Y = get_height(iter);      // top edge
    } else if (ball.y > get_height(iter)+bars_height[iter]) {
      corner_Y = get_height(iter) + bars_height[iter];   // bottom edge
    }

    // get distance from closest edges
    float distX = ball.x-corner_X;
    float distY = ball.y-corner_Y;
    float distance = sqrt( (distX*distX) + (distY*distY) );

    // if the distance is less than the radius, collision!
    if (distance <= radius) {
      return true;
    }
    return false;
  }

  Collision_Side ball_in_bar (Ball ball, int bar, int radius) {
    if (circleRect(ball, radius, bar)) {
      return  bar_to_ball_side(ball, get_height(bar), get_height_previous(bar), get_bar_left(bar), get_bar_left(bar + 1), radius);
    } else {
      return Collision_Side.NONE;
    }
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
