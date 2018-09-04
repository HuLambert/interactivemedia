//<>// //<>//


short absRound(float val)
{
  if (val < 0)
  {
    return (short)(floor(val));
  }
  return (short)(ceil(val));
}

Ball_Pair move_out (Ball_Pair balls, Bar_Manager bars, int radius) {
  //Assumption being made: B1 is colliding on the left
  Collision_Side col = bars.ball_in_any_bar(balls.b1, radius); 
  Collision_Side col_new;
  while (col != Collision_Side.NONE) {
    if (col == Collision_Side.TOP) {
      balls.b1.y--;
      balls.b2.y--;
    } else if (col == Collision_Side.RIGHT) {
      balls.b1.x++;
    } else if (col == Collision_Side.LEFT) {
      balls.b1.x--;
    }
    col_new = bars.ball_in_any_bar(balls.b1, radius);
    if (col_new != col) {
      break; //This is necessary to block infinite loops
    }
    col = col_new;
    
  }
  return balls;
}

Ball_Pair move_balls_outside_of_bars(Ball_Pair balls, Bar_Manager bars, int radius) {

  if (balls.b1.x > balls.b2.x) {
    balls.swap();
  }


  balls = move_out(balls, bars, radius);

  balls.swap();

  balls = move_out(balls, bars, radius);

  //Top ball goes up, bottom goes down
  balls = resolve_ball_collision_vertically(balls, radius);

  while (bars.ball_in_any_bar(balls.b1, radius) == Collision_Side.TOP | bars.ball_in_any_bar(balls.b2, radius) == Collision_Side.TOP) {
    balls.b1.y--;
    balls.b2.y--;
  }

  return balls;
}
