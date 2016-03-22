import de.bezier.data.sql.*;

GameController controller;

float SCALE = 10f;

MySQL dbconnection;

void connect() {
  String user     = "root";
  String pass     = " ";

  // name of the database to use
  //
  String database = "psv2";

  dbconnection = new MySQL( this, "localhost", database, user, pass );

  if ( dbconnection.connect() )
  {
  } else
  {
    System.out.println("!");
  }
}


void setup() {
  /*
  * Define the teams for the current match here
   */
  connect();
  controller = new GameController(new Match(
  // Team A Class
  CustomEmptyTeam.class, 
  // Team B Class
  CustomTeamB.class, 
  // Number of robots on each side
  11
    ));
  controller.getSimulator().setFieldSize(105f, 68f);
  
  controller.getMatchDetails();
  controller.getball();
  controller.getPlayers();
  controller.getReferees();
  controller.validateData();

  //######### do some calculations
  //controller.getPressureMeasurements();
  //controller.setBallTeamDistance();
  //controller.getOpponents();
  //controller.setIndividualDistance();
  //controller.getballPossessionSwitch();
  //controller.inserDistanceInDatabase();
  //controller.setDirectOpponent();
  //controller.getballPossessionSwitch();

  size((int)controller.getWidth(SCALE) + 200, (int)controller.getHeight(SCALE)+100);
}

void draw() {

  background(255);
  controller.run();

  translate(100, 0);
  controller.draw(this, SCALE);
  translate(-100, 0);
}

/*
	Finds out what is closer to the ball that can be moved,
 	and then move to that position
 */
public void mouseDragged() {
  // Checks what is closest to the mouse cursos (Robots and Ball)
  PVector mousePoint = new PVector((mouseX - 100) / SCALE, (mouseY - 150) / SCALE);

  float closestDist = 0.1f;
  Simulatable closest = controller.getSimulator().ball;

  for (Simulatable s : controller.getSimulator ().simulatables) {
    // Skip if not Ball or Robot
    if (!(s instanceof Ball || s instanceof Robot))
      continue;

    float dist = PVector.sub(s.getRealPosition(), mousePoint).mag();
    if (closestDist > dist) {
      closestDist = dist;
      closest = s;
    }
  }

  if (closest != null) {
    closest.position.set(mousePoint);
    closest.speed = new PVector();
    closest.accel = new PVector();
  }
}

public void keyPressed() {

  if (key == ' ') {
    if (!controller.hasStarted()) {
      System.out.println("Start game");
      controller.resetGame();
      controller.resumeGame();
    } else if (controller.isRunning()) {
      System.out.println("Pause game");
      controller.pauseGame();
    } else {
      System.out.println("Resume game");
      controller.resumeGame();
    }
  } else if (key == 'd') {
    String debug = "DEBUG:";
    debug += "\nisRunning:"+controller.isRunning();
    debug += "\nController Robots:"+controller.robots.size();
    for (Robot r : controller.robots)
      debug += "\n\t"+r+" ["+r.position.x+","+r.position.y+"]";

    debug += "\nSimulatables:"+controller.getSimulator().simulatables.size();
    for (Simulatable r : controller.getSimulator ().simulatables)
      debug += "\n\t"+r;

    System.out.println(debug);
  } else if (key == 's') {
    System.out.println("Skip 1 minute");
    controller.skipMinute();
  } else if (key == 'p') {
    System.out.println("go back 1 minute");
    controller.PreviousMinute();
  }
}

