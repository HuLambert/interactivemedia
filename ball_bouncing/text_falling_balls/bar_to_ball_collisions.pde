Collision_Side bar_to_ball_side(Ball ball, int bar_height_curr, int bar_height_old, int bar_left, int bar_right, int radius) { 
  
  //There's no way it can go from below to above
  if (ball.y_old > bar_height_curr) {
    if (ball.x_old < bar_left){
      return Collision_Side.LEFT;
    }
    return Collision_Side.RIGHT;
  }
  
  //Moving straight down
  if (ball.x - ball.x_old == 0) {
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
  }

  if (came_from_above) {
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
  if (bar_intercept + radius > bar_height_curr) {
    return ret;
  } else {
    return Collision_Side.TOP;
  }
}
