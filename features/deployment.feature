Feature: Robot deployment

  As a robot master
  I want to place the robot within the playground
  so that I can start to interact with it

  Scenario: Placement within the grid
    Given a robot is available
    When I deploy the robot at column "1" and row "2" facing "NORTH"
    And I ask to report the position
    Then the final position is column "1" and row "2" facing "NORTH"

  Scenario: Placement outside the grid
    Given a robot is available
    When I deploy the robot at column "7" and row "2" facing "NORTH"
    Then the application output is "Placement coordinates not valid"

  Scenario: Multiple placements
    Given a robot is available
    And I deploy the robot at column "1" and row "2" facing "NORTH"
    When I deploy the robot at column "2" and row "2" facing "NORTH"
    And I ask to report the position
    Then the final position is column "2" and row "2" facing "NORTH"
