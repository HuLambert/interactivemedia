//Doesn't work
void bar_to_ball_collisions_optimised() {
  int ball_iter = 0;
  int bar_iter = 0;
  int bar_width = width / bar_count;


  while (ball_iter < xyr.size() && bar_iter < bar_count)
  {
    int left_of_bar = bar_width * bar_iter;
    int right_of_bar = bar_width * (bar_iter + 1);
    int top_of_bar = height - bars[bar_iter];

    int radius = 16;

    int left_of_ball  = xyr.get(ball_iter).x - radius;
    int right_of_ball = xyr.get(ball_iter).x + radius; 

    //While the right of the ball is less than the left bar, keep iterating

    while (ball_iter < xyr.size() && right_of_ball < left_of_bar) {
      ball_iter++;
      if (ball_iter < xyr.size()) {
        right_of_ball = xyr.get(ball_iter).x + radius;
        left_of_ball  = xyr.get(ball_iter).x - radius;
      } else {
        break;
      }
    }

    int iter_all_balls = ball_iter;
    //Then while all the left of the balls are in the bar
    while (iter_all_balls < xyr.size() && right_of_ball < right_of_bar) {

      //We have an X collision
      int bottom_of_ball = xyr.get(iter_all_balls).y + radius;
      if (bottom_of_ball > top_of_bar) {
        //Collision handle
        handle_bar_to_ball_collision(iter_all_balls, bar_iter, radius);
      }
      iter_all_balls++;
      if (iter_all_balls < xyr.size()) {
        right_of_ball = xyr.get(iter_all_balls).x + radius;
        left_of_ball  = xyr.get(iter_all_balls).x - radius;
      } else {
        break;
      }
    }

    bar_iter++;
  }
}
