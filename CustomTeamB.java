import processing.core.*;
import java.util.*;
import java.sql.*;

public class CustomTeamB implements Team {

  private String host = "jdbc:mysql://localhost/psv2";
  private String uName = "root";
  private String uPass = " ";

  private Connection con;

  private Statement stmt;

  public String getTeamName() {
    String team_name = "Custom Team";
    try {

      con = DriverManager.getConnection(host, uName, uPass);
      stmt = con.createStatement();
      String sql = "SELECT name FROM teams WHERE team_id = 2";

      ResultSet rs = stmt.executeQuery(sql);
      int i = 0;

      if (rs.next ()) {
        team_name = rs.getString("name");
      }
      rs.close();
      stmt.close();
      con.close();
    }
    catch (SQLException err) {
      System.out.println( err.getMessage());
    }  
    return "Visiting Team";
    //return team_name;
  }

  public void setTeamSide(TeamSide side) {
  }

  public Robot buildRobot(GameSimulator s, int index) {
    return new EmptyRobot(s);
  }

  class EmptyRobot extends RobotBasic {
    EmptyRobot(GameSimulator s) {
      super(s);
    }

    public void setup() {
    }

    public void loop() {
    }


    public void decorateRobot(PApplet canvas) {
    }


    public void onStateChanged(String state) {
    }
  }
}

