Feature: Robot simple movement

  As a robot master
  I want to move the robot within the playground
  so that I can make it advance in the desired direction

  Scenario Outline: Moving the robot within the playground
    Given a robot is available
    And I deploy the robot at column "2" and row "2" facing "<Orientation>"
    When I run the following commands
      | Command |
      | MOVE    |
      | MOVE    |
    And I ask to report the position
    Then the final position is column "<Final Column>" and row "<Final Row>" facing "<Orientation>"

  Examples:
    | Orientation | Final Column | Final Row |
    | EAST        | 0            | 2         |
    | WEST        | 4            | 2         |
    | NORTH       | 2            | 4         |
    | SOUTH       | 2            | 0         |

