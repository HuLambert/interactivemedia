public enum Collision_Side {
  LEFT, RIGHT, TOP, NONE
};




class Ball_Bar_Collision {
  Ball_Bar_Collision(Collision_Side collision, int bar) {
   this.collision = collision;
   if (collision != Collision_Side.NONE){
     assert(bar > -1);
     this.bar = bar;
   }
  }
  
  boolean isColliding() {
    return collision != Collision_Side.NONE;
  }
  
  int bar = -1;
  Collision_Side collision = Collision_Side.NONE; 
}

Ball handle_bar_to_ball_collision(Ball ball, int bar_iter, Bar_Manager bars, Collision_Side col, int radius) {

  int left_of_bar = bars.get_bar_left(bar_iter);
  int right_of_bar = left_of_bar + bars.get_bar_width();
  
  switch (col) {
  case LEFT: {
      ball.vel_x = (byte)-(abs(ball.vel_x));
      ball.x = (short)(left_of_bar - radius);
      
      if (bar_iter > 0) {
        int new_bar_top = bars.get_height(bar_iter - 1); 
        
        //If snapping left caused us to go into the bar, we snap above that bar
        if (new_bar_top < ball.y) {
          ball.y = (short)(new_bar_top - (radius) - 1);
          ball.vel_y = (byte)-(abs(ball.vel_y));
        }
      }
      break;
    }
  case RIGHT: {
      ball.vel_x = (byte)(abs(ball.vel_x));
      ball.x = (short)(left_of_bar + bars.get_bar_width() + (radius) + 1);
      
      if (bar_iter < bars.bar_count() - 1) {
        int new_bar_top = bars.get_height(bar_iter + 1); 
        
        //If snapping right caused us to go into the bar, we snap above that bar
        if (new_bar_top < ball.y) {
          ball.y = (short)( (new_bar_top - radius) - 1);
          ball.vel_y = (byte)-(abs(ball.vel_y));
        }
        break;
      }
    }
  case TOP: {
      ball.vel_y = (byte)(-15);
      ball.y = (short)((bars.get_height(bar_iter) - radius) - 1);
      break;
    }
   case NONE: {
     break;
   }
  }
  return ball;  
}
