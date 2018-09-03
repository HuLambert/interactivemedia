 //<>//


short absRound(float val)
{
  if (val < 0)
  {
    return (short)(floor(val));
  }
  return (short)(ceil(val));
}


Ball_Pair move_balls_outside_of_bars(Ball b1, Ball b2, Bar_Manager bars, int radius) {

  if (b1.x > b2.x) {
    Ball swap = b1;
    b1 = b2;
    b2 = swap;
  }

  boolean move_both = false;
  if (bars.ball_in_any_bar(b1, radius) != Collision_Side.NONE && bars.ball_in_any_bar(b2, radius) != Collision_Side.NONE) {
    //We can't fit the balls side by side by the looks of it
    move_both = false;
  }

  //Assumption being made: B1 is colliding on the left
  Collision_Side col = bars.ball_in_any_bar(b1, radius); 
  
  while (col != Collision_Side.NONE) {
    if (col == Collision_Side.TOP) {
      b1.y--;
      b2.y--;
      println("RESOLVING FROM BOTTOM, CODE CHANGED FROM REFACTOR");
    } else {
      b1.x++;
      if (move_both) {
        b2.x++;
      }
    }
    col = bars.ball_in_any_bar(b1, radius); 
  }
  
  col = bars.ball_in_any_bar(b2, radius); 
  
  //Assumption being made: B2 is colliding on the right
  while (col != Collision_Side.NONE) {
    if (col == Collision_Side.TOP) {
      b1.y--;
      b2.y--;
      println("RESOLVING FROM BOTTOM, CODE CHANGED FROM REFACTOR");
    } else {
      b2.x--;
      if (move_both) {
        b1.x--;
      }
    }
    col = bars.ball_in_any_bar(b2, radius); 
  }

  //Top ball goes up, bottom goes down
  resolve_ball_collision_vertically(b1, b2, radius);
  
  
  while (bars.ball_in_any_bar(b1, radius) != Collision_Side.NONE | bars.ball_in_any_bar(b2, radius) != Collision_Side.NONE) {
    println("This has changed from the refactor, it made no sense before");
    b1.y--;
    b2.y--;
  }
  
  return new Ball_Pair(b1,b2);
}




//The top gets pushed up, bottom gets pushed down
void resolve_ball_collision_vertically(Ball top, Ball bottom, int radius) {
  if (top.y > bottom.y) {
    Ball swap = top;
    top = bottom;
    bottom = swap;
  }
  while (top.colliding_With_Ball(bottom, radius)) {
    top.y--;
    bottom.y++;
  }
}
