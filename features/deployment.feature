Feature: Robot deployment

  As a robot master
  I want to place the robot within the playground
  so that I can start to interact with it

  Scenario: Placement within the grid
    Given a robot is available
    When I deploy the robot at row "1" and column "2" facing "NORTH"
    And I ask to report the position
    Then the final position is row "1" and column "2" facing "NORTH"
