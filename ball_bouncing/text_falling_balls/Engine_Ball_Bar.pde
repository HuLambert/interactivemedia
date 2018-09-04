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
  int screen_width = 360;
  int screen_height = 480;

  void set_dimensions(int screen_width, int screen_height) {
    this.screen_width = screen_width;
    this.screen_height = screen_height;
    bars.set_dimensions(screen_width, screen_height);
  }

  void reset_balls() {
    for (int i = 0; i < balls.length; i++) {
      balls[i] = new Ball();
      balls[i].x = (short)((i * 60) %  screen_width);
      balls[i].y = (short)(random(-400, 300));
      balls[i].vel_x = (byte)(random(-60, 60));
    }
  }

  void draw() {
    String displaytext = "0123456789";
    color red = color(255, 0, 0, 255);
    color green = color(0, 255, 0, 255);
    color blue = color(0, 0, 255, 255);
    
    for (int i = 0; i < balls.length; i++) {
      balls[i].draw(radius, displaytext.charAt(i % displaytext.length()), red, green);
    }
    bars.draw(new color[]{blue, green});
  }

  public void update() {
    update_balls();
    bars.update_bars();
    engine.move_balls_into_bounds();
    engine.handle_collisions();
  }

  void update_balls() {
    for (Ball ball : balls) {
      ball.update();
    }
  }

  public void move_balls_into_bounds() {
    for (Ball ball : balls) {
      ball.ball_into_bounds(screen_width, screen_height, radius);
    }
  }

  void handle_collisions() {

    balls = bars.bar_to_ball_collisions(balls, radius);
    Arrays.sort(balls, new sortBallByX());
    Handle_Ball_To_Ball_Collisions();
  }

  public void Handle_Ball_To_Ball_Collisions() {
    boolean collision_found = false;
    byte iteration_limit = 100; //We define a limit for collisions
    byte iteration_limit_count = 0;

    for (int i = 0; i < balls.length; i++) {
      collision_found = false;
      for (int j = i + 1; j < balls.length && collision_found == false; j++) {
        if (balls[i].colliding_With_Ball(balls[j], radius)) {
          int overlap_padding = 4; //Can be anything
          Ball_Pair resolved_balls = handle_collision_with_balls(new Ball_Pair(balls[i], balls[j]), radius, overlap_padding);
          resolved_balls.swap();
          resolved_balls = move_balls_outside_of_bars(resolved_balls, bars, radius);
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
