public enum Collision_Side {
  LEFT, RIGHT, TOP
};


void bar_to_ball_collisions (int radius) {
  int bar_width = ceil(width / bar_count);
  int left_of_bar  = 0; //bar_width * i;
  int right_of_bar = 0;//bar_width * (i + 1);
  int top_of_bar = 0;

  int left_of_ball  = 0; //xyr.get(ball_iter).x - radius;
  int right_of_ball = 0; //xyr.get(ball_iter).x + radius; 
  int bottom_of_ball = 0;
  for (int i = 0; i < bar_count; i++)
  {
    left_of_bar = bar_width * i;
    right_of_bar = bar_width * (i + 1);
    top_of_bar = height - bars[i];

    for (int j = 0; j < xyr.size(); j++)
    {
      left_of_ball  = xyr.get(j).x - radius;
      right_of_ball = xyr.get(j).x + radius;
      bottom_of_ball = xyr.get(j).y + radius;

      if (left_of_ball < right_of_bar) {
        if (right_of_ball > left_of_bar) {
          if (bottom_of_ball > top_of_bar) {
            handle_bar_to_ball_collision(j, i, radius);
          }
        }
      }
    }
  }
}

Collision_Side bar_to_ball_with_eq(item ball, int bar_height_curr, int bar_height_old, int bar_left, int bar_right, int radius) { 

  if (ball.x - ball.x_old == 0) {
    println("    Hit from top, early resolve from straight down");
    return (Collision_Side.TOP);
  }
  //Bodge, needs to be done seperately

  int ball_left_prev = ball.x_old - radius;
  int ball_right_prev = ball.x_old + radius;
  boolean was_previously_in_lines = 
    ((ball_right_prev > bar_left) && (ball_left_prev < bar_right)) 
    | 
    ((ball_left_prev < bar_right) && (ball_right_prev > bar_left));

  int ball_left = ball.x - radius;
  int ball_right = ball.x + radius;
  boolean in_lines = 
    ((ball_right > bar_left) && (ball_left < bar_right)) 
    | 
    ((ball_left < bar_right) && (ball_right > bar_left));

  if (in_lines && was_previously_in_lines) {
    println("    Hit from top, early resolve");
    return (Collision_Side.TOP);
  }
  //If the ball was |o| it could only have hit this bar from the top. 
  boolean came_from_above = 
    was_previously_in_lines
    && (ball.y_old <= bar_height_curr);

  boolean came_from_above_2 = 
    was_previously_in_lines
    && (ball.y_old < bar_height_old);

  if (came_from_above != came_from_above_2) {
    println("Previously Above");
  }

  if (came_from_above) {
    println("    Hit from top, early resolve");
    return (Collision_Side.TOP);
  }
  float gradiant = (float)(ball.y - ball.y_old) / float(ball.x - ball.x_old);
  float y_intercept = ball.y - (float)(gradiant * ball.x_old);

  float x = (bar_height_curr - y_intercept) / gradiant;
  float bar_intercept = 0;
  Collision_Side ret;


  if (ball.x_old - radius <= bar_left) {
    bar_intercept = (gradiant * bar_left) + y_intercept; //Came from left
    ret = Collision_Side.LEFT;
  } else {
    bar_intercept = (gradiant * bar_right) + y_intercept; //Came from right
    ret = Collision_Side.RIGHT;
  }
  if (bar_intercept + radius >= bar_height_curr) {
    println("    From the side");
    return ret;
  } else {
    println("   From the top");
    return Collision_Side.TOP;
  }
}

boolean ball_in_any_bar(int i, int radius)
{
  PVector p = new PVector(xyr.get(i).x, xyr.get(i).y);
  return point_in_any_bar(p, radius);
}
boolean point_in_any_bar(PVector point, int radius) {
  int bar_width = ceil(width / bar_count);
  int left_of_bar  = 0;
  int right_of_bar = 0;
  int top_of_bar =  0;

  int left_of_ball  = (int)(point.x - radius); //bar_width * i;; //xyr.get(ball_iter).x - radius;
  int right_of_ball = (int)(point.x + radius); //xyr.get(ball_iter).x + radius; 
  int bottom_of_ball = (int)(point.y + radius);
  for (int i = 0; i < bar_count; i++)
  {
    left_of_bar = bar_width * i;
    right_of_bar = bar_width * (i + 1);
    top_of_bar = height - bars[i];
    if (left_of_ball < right_of_bar) {
      if (right_of_ball > left_of_bar) {
        if (bottom_of_ball > top_of_bar) {
          return true;
        }
      }
    }
  }
  return false;
}


boolean point_in_bar(int left_of_bar, int bar_width, float top_of_bar, PVector point, int radius) {
  float left_of_ball  = point.x - radius;
  float right_of_ball = point.x + radius;
  float bottom_of_ball = point.y + radius;

  int right_of_bar = left_of_bar + bar_width;

  if (left_of_ball < right_of_bar) {
    if (right_of_ball > left_of_bar) {
      if (bottom_of_ball > top_of_bar) {
        return true;
      }
    }
  }
  return false;
}

void handle_bar_to_ball_collision(int ball_iter, int bar_iter, int radius) {
  int bar_top = height - bars[bar_iter];
  int bar_width = ceil(width / bar_count);
  int left_of_bar = bar_width * bar_iter;
  println(ball_iter);
  Collision_Side col = bar_to_ball_with_eq(xyr.get(ball_iter), bar_top, bar_top - bar_vel[bar_iter], left_of_bar, left_of_bar + bar_width, radius);
  switch (col)
  {
  case LEFT: 
    {
      xyr.get(ball_iter).vel_x = (byte)-(abs(xyr.get(ball_iter).vel_x));
      xyr.get(ball_iter).x = (short)((left_of_bar - (radius)) - 1);
      fill(255, 255, 255, 100);
      ellipse(xyr.get(ball_iter).x, xyr.get(ball_iter).y, radius * 2, radius * 2); 
      if (bar_iter > 0) {
        int new_bar_top = height - bars[bar_iter - 1];
        if (new_bar_top < xyr.get(ball_iter).y) {
          xyr.get(ball_iter).y = (short)(new_bar_top - (radius) - 1);
          xyr.get(ball_iter).vel_y = (byte)-(abs(xyr.get(ball_iter).vel_y));
        }
      }
      break;
    }
  case RIGHT: 
    {
      xyr.get(ball_iter).vel_x = (byte)(abs(xyr.get(ball_iter).vel_x));
      xyr.get(ball_iter).x = (short)(left_of_bar + bar_width + (radius) + 1);
      fill(255, 255, 255, 100);
      ellipse(xyr.get(ball_iter).x, xyr.get(ball_iter).y, radius * 2, radius * 2); 

      if (bar_iter < bar_count - 1) {
        int new_bar_top = height - bars[bar_iter + 1];
        fill(255, 255, 255, 100);
        ellipse(xyr.get(ball_iter).x, xyr.get(ball_iter).y, radius * 2, radius * 2); 
        if (new_bar_top < xyr.get(ball_iter).y) {
          xyr.get(ball_iter).y = (short)(new_bar_top - (radius) - 1);
          xyr.get(ball_iter).vel_y = (byte)-(abs(xyr.get(ball_iter).vel_y));
        }
        break;
      }
    }
  case TOP: 
    {
      xyr.get(ball_iter).vel_y = (byte)-(abs(xyr.get(ball_iter).vel_y));
      xyr.get(ball_iter).y = (short)(bar_top - (radius) - 1);
      fill(255, 255, 255, 100);
      ellipse(xyr.get(ball_iter).x, xyr.get(ball_iter).y, radius * 2, radius * 2); 
      break;
    }
  }
}
//Snaps and re-directs ball
