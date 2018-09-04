class Ball_Pair {
  Ball_Pair(Ball b1, Ball b2) {
    this.b1 = b1;
    this.b2 = b2;
  }
  Ball b1;
  Ball b2;
  
  void swap() {
    Ball swap = b1;
    b1 = b2;
    b2 = swap;
    
  }
}


Ball_Pair handle_collision_with_balls(Ball_Pair balls, int radius, int padding) {
  PVector_Pair dirs = resolve_overlap(balls.b1, balls.b2, radius, padding);

  //We then apply the new direction, to move out of the depth
  //1.1 is a randomly chosen number, must be negative.
  balls.b1.apply_Vel_ABSround(dirs.v1.mult(-1.1));
  balls.b2.apply_Vel_ABSround(dirs.v2.mult(-1.1));

  //To simply transfer vel, we swap the vels of both balls
  balls.b2 = balls.b1.swap_vel(balls.b2);

  return balls;
}

//The top gets pushed up, bottom gets pushed down
Ball_Pair resolve_ball_collision_vertically(Ball_Pair balls, int radius) {
  if (balls.b1.y > balls.b2.y) {
    balls.swap();
  }
  while (balls.b1.colliding_With_Ball(balls.b2, radius)) {
    balls.b1.y--;
    balls.b2.y++;
  }
  return balls;
}
