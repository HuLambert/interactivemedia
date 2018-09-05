//A class to handle balls and bars
class Engine_Ball_Bar {
  public Engine_Ball_Bar (Ball_Manager balls, Bar_Manager bars, int screen_width, int screen_height) {
    this.balls = balls;
    this.bars = bars;
    this.screen_width = screen_width; 
    this.screen_height = screen_height;
    balls.reset_balls(screen_width);
    pg = createGraphics(screen_width,screen_height);
    pg.beginDraw();
    pg.endDraw();
  }
  
  int screen_width = 0;
  int screen_height = 0;
  PGraphics pg; 

  void set_dimensions(int screen_width, int screen_height) {
    this.screen_width = screen_width;
    this.screen_height = screen_height;
    bars.set_dimensions(screen_width, screen_height);
  }



  PGraphics draw() {
    pg.beginDraw();
    pg.rotate(0);
    pg.background(0);
    pg.textSize(balls.getRadius() * 2);
    pg.textAlign(CENTER, CENTER);
    String displaytext = "0123456789";
    color red = color(255, 0, 0, 255);
    color green = color(0, 255, 0, 255);
    color blue = color(0, 0, 255, 255);

    pg = balls.draw(pg, displaytext, red, green);

    pg = bars.draw(pg, new color[]{red, green, blue});
    pg.endDraw();
    return pg;
  }

  public void update() {
    balls.update_balls();
    bars.update_bars();
    balls.move_balls_into_bounds(screen_width, screen_height);
    handle_collisions();
  }


  void handle_collisions() {
    balls.bar_to_ball_collisions(bars);
    balls.sortByX();
    balls.Handle_Ball_To_Ball_Collisions(bars);
  }

  private Bar_Manager bars;
  private Ball_Manager balls;
}
