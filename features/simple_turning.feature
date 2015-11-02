Feature: Robot simple turning

  As a robot master
  I want to change the orientation of the robot
  so that I can direct it in the desired direction

  Scenario Outline: Turning the robot
    Given a robot is available
    And I deploy the robot at column "2" and row "2" facing "<Orientation>"
    When I run the following commands
      | Command |
      | LEFT    |
      | LEFT    |
      | LEFT    |
      | RIGHT   |
    And I ask to report the position
    Then the final position is column "2" and row "2" facing "<Final Orientation>"

  Examples:
    | Orientation | Final Orientation |
    | EAST        | WEST              |
    | WEST        | EAST              |
    | NORTH       | SOUTH             |
    | SOUTH       | NORTH             |

