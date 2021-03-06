final int millisActive     = 5000;
final int millisIdle       = 5000;
final int millisTransition = 5000;

Idle idle;
Active active;

State state = State.IDLE;
boolean activeHasBeenReinstantiated = false;
int timeAtTransition = 0;

void setup() {
  active = new Active(this);
  idle = new Idle(this);
}

void draw() {
  switch(state) {
    case ACTIVE:
      // draw the active object
      active.draw();
      
      // check if we have elapsed the active timeframe
      if(millis() > timeAtTransition + millisActive) {
        transition(false);
      }
      break;
      
    case IDLE:
      // draw the active object
      idle.draw();
      
      // check if we have elapsed the active timeframe
      if(millis() > timeAtTransition + millisIdle) {
        transition(true);
      }
      break;
      
    case ACTIVE_TO_IDLE:
      // transition from active to idle
      print("active to idle");
      break;
      
    case IDLE_TO_ACTIVE:
      // transition from idle to active
      print("idle to active");
      break;
  }
}

void transition(boolean toActive) {
  if (toActive) {
    print("idle to active");
    state = State.ACTIVE;
    timeAtTransition = millis();
  } else {
    print("active to idle");
    state = State.IDLE;
    activeHasBeenReinstantiated = false;
    timeAtTransition = millis();
  }
}
