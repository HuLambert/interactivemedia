//A class to handle balls and bars
class Engine_Ball_Bar {

  public Engine_Ball_Bar (int ball_count, int bar_count, int radius) {
    balls = new Ball[ball_count]; 
    bars = new Bar_Manager(bar_count);
    this.radius = radius;
    reset_balls();
    textSize(radius * 2);
    textAlign(CENTER, CENTER);
  }
  void reset_balls() {
    for (int i = 0; i < balls.length; i++) {
      balls[i] = new Ball();
      balls[i].x = (short)((i * 60) %  width);
      balls[i].y = (short)(random(-400, 300));
      balls[i].vel_x = (byte)(random(-30, 30));
    }
  }

  void draw() {
    String displaytext = "Hello World";
    for (int i = 0; i < balls.length; i++) {
      balls[i].draw(radius, displaytext.charAt(i % displaytext.length()));
    }
    bars.draw();
  }

  public void update() {
    update_balls();
    bars.update_bars();
  }
  
  void update_balls() {
    for (Ball ball : balls) {
      ball.update();
    }
  }

  public void move_balls_into_bounds() {
    for (Ball ball : balls) {
      ball.ball_into_bounds(width, height, radius);
    }
  }

  void handle_collisions() {
    Arrays.sort(balls, new sortBallByX());
    balls = bars.bar_to_ball_collisions(balls, radius);
    Arrays.sort(balls, new sortBallByX());
    Handle_Ball_To_Ball_Collisions();
    Arrays.sort(balls, new sortBallByX());
  }

  public void Handle_Ball_To_Ball_Collisions() {
    boolean collision_found = false;
    byte iteration_limit = 100; //We define a limit for collisions
    byte iteration_limit_count = 0;

    for (int i = 0; i < balls.length; i++) {
      collision_found = false;
      for (int j = i + 1; j < balls.length && collision_found == false; j++) {
        if (balls[i].colliding_With_Ball(balls[j], radius)) {
          int overlap_padding = 0; //Can be anything
          Ball_Pair resolved_balls = handle_collision_with_balls(balls[i], balls[j], radius, overlap_padding);
          resolved_balls = move_balls_outside_of_bars(resolved_balls.b1, resolved_balls.b2, bars, radius);
          balls[i] = resolved_balls.b1;
          balls[j] = resolved_balls.b2;

          iteration_limit++;
          if (iteration_limit_count > iteration_limit) {
            break;
          }
          collision_found = true;
          i = 0;
          iteration_limit_count++;
        }
      }
    }
  }

  private Ball[] balls;
  private Bar_Manager bars;
  int radius;
}

class Ball_Pair {
  Ball_Pair(Ball b1, Ball b2) {
    this.b1 = b1;
    this.b2 = b2;
  }
  Ball b1;
  Ball b2;
}


class PVector_Pair {
  PVector_Pair(PVector v1, PVector v2) {
    this.v1 = v1;
    this.v2 = v2;
  }
  PVector v1;
  PVector v2;
}


PVector_Pair resolve_overlap(Ball lhs, Ball rhs, int radius, int padding) {
  //We then get the vectors of each ball's current motion

  PVector lhs_bounceback_dir =  lhs.get_bounceback(rhs).normalize(); //Normal Vector
  PVector rhs_bounceback_dir =  rhs.get_bounceback(lhs).normalize(); //Normal Vector

  //We get the depth of the collision
  float overlap_depth = lhs.overlap_depth(rhs, radius + padding);

  //To distribute the distance we must move each point, we divide by two
  float divisor = ceil(overlap_depth) / 2.0;


  float bounceback_padding = 0; //Add a little extra 
  lhs_bounceback_dir = lhs_bounceback_dir.mult(divisor + bounceback_padding); 
  rhs_bounceback_dir = rhs_bounceback_dir.mult(divisor + bounceback_padding);

  return new PVector_Pair(lhs_bounceback_dir, rhs_bounceback_dir);
}

//padding would be 4
Ball_Pair handle_collision_with_balls(Ball lhs, Ball rhs, int radius, int padding) {
  PVector_Pair dirs = resolve_overlap(lhs, rhs, radius, padding);

  //We then apply the new direction, to move out of the depth
  lhs.apply_Vel_ABSround(dirs.v1);
  rhs.apply_Vel_ABSround(dirs.v2);

  //To simply transfer vel, we swap the vels of both balls
  rhs = lhs.swap_vel(rhs);


  //I honeslty have no fucking clue how this happens.
  //This function is different from previous to the refactor
  //Investigate here if errors are occurding
  if (lhs.colliding_With_Ball(rhs, radius)) {
    PVector_Pair dirs_2 = resolve_overlap(lhs, rhs, radius, padding); //<>// //<>//
    lhs.apply_Vel_ABSround(dirs_2.v1.mult(2));
    println("This function is experimental, if errors with collisions occur check here");
  }

  return new Ball_Pair(lhs, rhs); //<>// //<>//
}
