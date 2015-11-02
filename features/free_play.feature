Feature: Robot free play

  As a robot master
  I want to change orientation, move and deploy the robot
  so that I can play with it

  Scenario: Example a
    Given a robot is available
    And I deploy the robot at column "0" and row "0" facing "NORTH"
    When I run the following commands
      | Command |
      | MOVE    |
    And I ask to report the position
    Then the final position is column "0" and row "1" facing "NORTH"

  Scenario: Example b
    Given a robot is available
    And I deploy the robot at column "0" and row "0" facing "NORTH"
    When I run the following commands
      | Command |
      | LEFT    |
    And I ask to report the position
    Then the final position is column "0" and row "0" facing "WEST"

  Scenario: Example c
    Given a robot is available
    And I deploy the robot at column "1" and row "2" facing "EAST"
    When I run the following commands
      | Command |
      | MOVE    |
      | MOVE    |
      | LEFT    |
      | MOVE    |
    And I ask to report the position
    Then the final position is column "3" and row "3" facing "NORTH"
