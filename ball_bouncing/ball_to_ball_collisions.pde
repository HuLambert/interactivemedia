//<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//

boolean do_balls_collide(int i, int j, int radius) {
  PVector i_point = new PVector(xyr.get(i).x, xyr.get(i).y);
  PVector j_point = new PVector(xyr.get(j).x, xyr.get(j).y);
  return balls_colliding(i_point, j_point, radius);
}

boolean balls_colliding (PVector i_point, PVector j_point, int radius) {
  float distance = i_point.dist(j_point) ;
  return (ceil(distance) < (radius) * 2);
}

int absRound(float val)
{
  if (val < 0)
  {
    return floor(val);
  }
  return ceil(val);
}


void resolve_bar_collisions(int i, int j, int radius) {

  if (xyr.get(i).x > xyr.get(j).x) {
    int swap = i;
    i = j;
    j = swap;
  }
  boolean move_both = false;
  if (ball_in_any_bar(i, radius) && ball_in_any_bar(j, radius)) {
    print("UNSOLVABLE");
    /*
    while (do_balls_collide(i, j, radius)) {
     xyr.get(i).y--;
     xyr.get(j).y++;
     */
    move_both = false;
  }





  //We're going to assume i is to the left of j
  while (ball_in_any_bar(i, radius)) {
    if (get_Ball_and_Bar_collision_side_by_iter(i, radius) == Collision_Side.TOP) {
      xyr.get(i).y--;
      xyr.get(i).y--;
      println("RESOLVING FROM BOTTOM");
    } else {
      xyr.get(i).x++;
      if (move_both) {
        xyr.get(j).x++;
      }
    }
  }
  while (ball_in_any_bar(j, radius)) {
    if (get_Ball_and_Bar_collision_side_by_iter(j, radius) == Collision_Side.TOP) {
      xyr.get(j).y--;
      xyr.get(j).y--;
      println("RESOLVING FROM BOTTOM");
    } else {
      xyr.get(j).x--;
      if (move_both) {
        xyr.get(i).x--;
      }
    }
  }
  while (do_balls_collide(i, j, radius)) {
    xyr.get(i).y--;
    xyr.get(j).y++;
  }

  while (ball_in_any_bar(i, radius) && ball_in_any_bar(j, radius)) {
    xyr.get(i).y++;
    xyr.get(j).y++;
  }
}
void handle_collision(int i, int j, int radius) {

  PVector i_point = new PVector(xyr.get(i).x, xyr.get(i).y);
  PVector j_point = new PVector(xyr.get(j).x, xyr.get(j).y);

  //We get the depth of the collision
  float depth = ((radius + 4) * 2.0) - i_point.sub(j_point).mag();

  //We then get the vectors of each ball's current motion
  PVector i_vel = new PVector(xyr.get(i).vel_x, xyr.get(i).vel_y);
  PVector j_vel = new PVector(xyr.get(j).vel_x, xyr.get(j).vel_y);

  //We then subtract the unit vectors, to give a new direction for both balls to move in
  PVector dir_i_unit = PVector.sub(i_vel, j_vel).normalize(); //Potentially too small a value
  PVector dir_j_unit = PVector.sub(j_vel, i_vel).normalize(); //Potentially too small a value

  //To distribute the distance we must move each point, we divide by two
  float divisor = ceil(depth) / 2.0;

  dir_i_unit = dir_i_unit.mult((divisor) + 0.5); 
  dir_j_unit = dir_j_unit.mult((divisor) + 0.5);

  //We then apply the new direction, to move out of the depth
  xyr.get(i).x += absRound(dir_j_unit.x); //Make Floor Ceil Func
  xyr.get(i).y += absRound(dir_j_unit.y);

  //We then apply the new direction, to move out of the depth
  xyr.get(j).x += absRound(dir_i_unit.x);
  xyr.get(j).y += absRound(dir_i_unit.y);



  //For simplicity, we swap the vels of both balls
  byte i_old_vel_x = xyr.get(i).vel_x;
  byte i_old_vel_y = xyr.get(i).vel_y;

  xyr.get(i).vel_x = xyr.get(j).vel_x;
  xyr.get(i).vel_y = xyr.get(j).vel_y;

  xyr.get(j).vel_x = i_old_vel_x; 
  xyr.get(j).vel_y = i_old_vel_y; 


  //I honeslty have no fucking clue how this happens.
  //Code prior should move it out
  if (do_balls_collide(i, j, radius)) {
    PVector i_point_2 = new PVector(xyr.get(i).x, xyr.get(i).y);
    PVector j_point_2 = new PVector(xyr.get(j).x, xyr.get(j).y);
    float distance_2 = (radius * 2) - i_point_2.dist(j_point_2);
    xyr.get(i).x += distance_2;
    xyr.get(i).y += distance_2;
  }
  dir_j_unit.normalize();
  dir_i_unit.normalize();
  resolve_bar_collisions(i, j, radius);

  if (ball_in_any_bar(i, radius)) {
    println("    I In da bar " + ball_in_any_bar(j, radius));
   
  }
  if (ball_in_any_bar(j, radius)) {
    println("    J In da bar " + ball_in_any_bar(i, radius));

  }
  //Swap vels
}

void ball_to_ball_collisions (int radius) { 
  boolean collision_found = false;
  int limit = 0;
  for (int i = 0; i < xyr.size(); i++) {
    collision_found = false;
    for (int j = i + 1; j < xyr.size() && collision_found == false; j++) {
      if (do_balls_collide(i, j, radius)) {
        //draw_all_items("HELLOWORLD");
        handle_collision(i, j, radius);


        Collections.sort(xyr, new sortByX());
        fill(200);

        limit++;

        if (limit > 100) {
          print(" Overlap accepted "); 
        } else {
          collision_found = true;
          i = 0;
        }
      }
    }
  }
}
