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


  Scenario: From origin to the opposite corner
    Given a robot is available
    And I deploy the robot at column "0" and row "0" facing "NORTH"
    When I run the following commands
      | Command |
      | RIGHT   |
      | MOVE    |
      | LEFT    |
      | MOVE    |
      | MOVE    |
      | RIGHT   |
      | MOVE    |
      | MOVE    |
      | LEFT    |
      | MOVE    |
      | RIGHT   |
      | MOVE    |
      | LEFT    |
      | MOVE    |
      | RIGHT   |
      | MOVE    |
    And I ask to report the position
    Then the final position is column "4" and row "4" facing "EAST"

  Scenario: Self destruction while going back to origin
    Given a robot is available
    And I deploy the robot at column "2" and row "2" facing "WEST"
    When I run the following commands
      | Command |
      | MOVE    |
      | LEFT    |
      | MOVE    |
      | RIGHT   |
      | MOVE    |
      | MOVE    |
      | MOVE    |
    And I ask to report the position
    Then the final position is column "0" and row "1" facing "WEST"

  Scenario: Replace the robot when at the corner
    Given a robot is available
    And I deploy the robot at column "1" and row "1" facing "SOUTH"
    When I run the following commands
      | Command |
      | MOVE    |
      | RIGHT   |
      | MOVE    |
    And I deploy the robot at column "1" and row "2" facing "NORTH"
    When I run the following commands
      | Command |
      | MOVE    |
    And I ask to report the position
    Then the final position is column "1" and row "3" facing "NORTH"
