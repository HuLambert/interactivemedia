void update_balls() {
  byte gravity_x = 0;
  byte gravity_y = 1;

  for (int i = 0; i < xyr.size(); i++) {
    //Collision work, only checks ahead
    xyr.get(i).x += xyr.get(i).vel_x;    
    xyr.get(i).y += xyr.get(i).vel_y;
    byte terminal_velocity = 15;
    xyr.get(i).vel_x += xyr.get(i).accel_x;    
    xyr.get(i).vel_y += xyr.get(i).accel_y;
    
    if ( xyr.get(i).vel_x < 0) {
      xyr.get(i).vel_x = (byte)(max(xyr.get(i).vel_x, -terminal_velocity));
    } else {
      xyr.get(i).vel_x = (byte)(min(xyr.get(i).vel_x, terminal_velocity));
    }
    
    if ( xyr.get(i).vel_y < 0) {
      xyr.get(i).vel_y = (byte)(max(xyr.get(i).vel_y, -terminal_velocity));
    } else {
      xyr.get(i).vel_y = (byte)(min(xyr.get(i).vel_y, terminal_velocity));
    }
    
    

    xyr.get(i).accel_x = gravity_x;
    xyr.get(i).accel_y = gravity_y;
  }
  Collections.sort(xyr, new sortByX());
}

void balls_into_bounds(int radius) {
  for (int i = 0; i < xyr.size(); i++) {
    move_ball_in_bounds(i, radius);
  }
}

void move_ball_in_bounds (int i, int radius) {
  if (xyr.get(i).y > height - radius) {
    xyr.get(i).y = (short)(height - radius);
    xyr.get(i).vel_y = (byte)(xyr.get(i).vel_y * -0.9);  
    xyr.get(i).vel_x = (byte)(random(-10, 10));
  }
  if (xyr.get(i).x + radius < 0) {
    xyr.get(i).x = 0;
    xyr.get(i).y = 0;
    xyr.get(i).vel_x = (byte)(abs(xyr.get(i).vel_x));
  }
  if (xyr.get(i).x - radius >= width ) {
    xyr.get(i).x = (short)(width);
    xyr.get(i).y = 0;
    xyr.get(i).vel_x = (byte)(-abs(xyr.get(i).vel_x));
  }
}
