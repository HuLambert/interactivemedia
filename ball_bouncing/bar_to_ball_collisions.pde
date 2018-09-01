//I am disgusted that this is copy paste code. 



Collision_Side get_Ball_and_Bar_collision_side_by_iter (int ball_i, int radius) {
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


    left_of_ball  = xyr.get(ball_i).x - radius;
    right_of_ball = xyr.get(ball_i).x + radius;
    bottom_of_ball = xyr.get(ball_i).y + radius;

    if (left_of_ball < right_of_bar) {
      if (right_of_ball > left_of_bar) {
        if (bottom_of_ball > top_of_bar) {
          return bar_to_ball_with_eq(xyr.get(ball_i), top_of_bar, top_of_bar - bar_vel[i], left_of_bar, left_of_bar + bar_width, radius);
        }
      }
    }
  }
  return Collision_Side.NONE;
}
