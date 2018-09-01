void update_bars () {
  //Hard coding needs to be removed
  for (int i = 0; i < bar_count; i++) {
    short rand = (short)(random(-60, 60));
    short old_bar = bars[i];
    
    bars[i] = (short)(max(bars[i] + rand, 20));
    bar_vel[i] = (short)(bars[i] - old_bar);
  }
}
