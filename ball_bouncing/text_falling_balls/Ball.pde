class Ball {

  PVector get_Position() {
    return new PVector(x, y);
  }


  PVector get_Vel() {
    return new PVector(vel_x, vel_y);
  }

  PVector get_bounceback(Ball rhs) {
    return PVector.sub(get_Vel(), rhs.get_Vel());
  }

  void draw(int radius, char text, color ball_color, color text_color) {
    fill(ball_color);
    ellipse(x, y, radius * 2, radius * 2); 
    fill(text_color);
    text(text, x, y - 4);
  }

  //Rounds 0.4 to 1, and -0.4 to -1
  void apply_Vel_ABSround (PVector vel) {
    x += absRound(vel.x);
    y += absRound(vel.y);
  }

  int get_left_of_ball(int radius) {
    return x - radius;
  }

  int get_right_of_ball(int radius) {
    return x + radius;
  }

  int get_bottom_of_ball(int radius) {
    return y + radius;
  }
  //Swaps the vels, and returns the new RHS
  Ball swap_vel(Ball rhs) {
    //For simplicity, we swap the vels of both balls
    byte old_vel_x = vel_x;
    byte old_vel_y = vel_y;
    vel_x = rhs.vel_x;
    vel_y = rhs.vel_y;
    rhs.vel_x = old_vel_x;
    rhs.vel_y = old_vel_y;
    return rhs;
  }

  //Assumes the same radius
  boolean colliding_With_Ball (Ball rhs, int radius) { 
    float distance = get_Position().dist(rhs.get_Position()) ;
    return (ceil(distance) < (radius) * 2);
  }
  float overlap_depth (Ball rhs, int radius) {
    return overlap_depth(rhs.get_Position(),radius);
  }
  float overlap_depth (PVector rhs, int radius) {
    return ((radius) * 2.0) - get_Position().sub(rhs).mag();
  }

  void update() {
    x_old = x; 
    y_old = y;

    byte terminal_velocity = 15;
    byte gravity_x = 0;
    byte gravity_y = 1;

    x += vel_x;
    y += vel_y; 

    vel_x += accel_x;
    vel_y += accel_y;
    if (vel_x < 0) {
      vel_x = (byte)(max(vel_x, -terminal_velocity));
    } else {
      vel_x = (byte)(min(vel_x, terminal_velocity));
    }
    //Collision work, only checks ahead

    if (vel_y < 0) {
      vel_y = (byte)(max(vel_y, -terminal_velocity));
    } else {
      vel_y = (byte)(min(vel_y, terminal_velocity));
    }

    accel_x = gravity_x;
    accel_y = gravity_y;
  }

  void ball_into_bounds(int max_width, int max_height, int radius) {
    if (y > max_height - radius) {
      y = (short)(max_height - radius);
      vel_y = (byte)(vel_y * -0.9);  
      vel_x = (byte)(random(-10, 10));
    }
    if (x + radius < 0) {
      x = 0;
      y = 0;
      vel_x = (byte)(abs(vel_x));
    }
    if (x - radius >= max_width ) {
      x = (short)(max_width);
      y = 0;
      vel_x = (byte)(-abs(vel_x));
    }
  }


  short x; 
  short y; 

  short x_old; 
  short y_old; 

  byte vel_x; 
  byte vel_y; 
  byte vel_deg; 
  byte accel_x; 
  byte accel_y; 

  String toString() {
    return 
      x + " " + 
      y + " " + 
      vel_x + " " + 
      vel_y + " ";
  }
}



class sortBallByX implements Comparator<Ball> {
  public int compare(Ball lhs, Ball rhs) {
    return int(lhs.x - rhs.x);
  }
}
