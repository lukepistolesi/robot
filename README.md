Toy Robot Simulator
===================

### Description
-------------
- The application is a simulation of a toy robot moving on a square tabletop, of dimensions 5 units x 5 units.
- There are no other obstructions on the table surface.
- The robot is free to roam around the surface of the table, but must be prevented from falling to destruction. Any movement that would result in the robot falling from the table must be prevented, however further valid movement commands must still be allowed.

### Commands
-------------
Create an application that can read in commands of the following form:
  - `PLACE X,Y,F`
  - `MOVE`
  - `LEFT`
  - `RIGHT`
  - `REPORT`

##### PLACE
will put the toy robot on the table in position X,Y and facing _NORTH_, _SOUTH_, _EAST_ or _WEST_.
- The origin (0,0) can be considered to be the SOUTH WEST most corner.
- The first valid command to the robot is a PLACE command, after that, any sequence of commands may be issued, in any order, including another PLACE command. The application should discard all commands in the sequence until a valid PLACE command has been executed.

##### MOVE
will move the toy robot one unit forward in the direction it is currently facing.

##### LEFT and RIGHT
will rotate the robot 90 degrees in the specified direction without changing the position of the robot.

##### REPORT
will announce the X,Y and orientation of the robot.
- A robot that is not on the table can choose to ignore the MOVE, LEFT, RIGHT and REPORT commands.
- Provide test data to exercise the application.


### Constraints
---------------
The toy robot must not fall off the table during movement. This also includes the initial placement of the toy robot.
Any move that would cause the robot to fall must be ignored.

#### Example Input and Output:
*a)*
- `PLACE 0,0,NORTH`
- `MOVE`
- `REPORT`
- Output: 0,1,NORTH

*b)*
- `PLACE 0,0,NORTH`
- `LEFT`
- `REPORT`
- Output: 0,0,WEST

*c)*
- `PLACE 1,2,EAST`
- `MOVE`
- `MOVE`
- `LEFT`
- `MOVE`
- `REPORT`
- Output: 3,3,NORTH


### Deliverables
----------------
The source files, the test data and any test code.


# Install instruction
---------------------
The codebase is pretty straight forward and it has the version.conf file to be automatically used by RVM to setup ruby and gems.

Hopefully while entering the application directory, RVM kicks in, creates the gemset for the project and install the gems.

Someuseful commands to run are for development purpose:

- `rspec` to run unit tests and coverage.

- `NO_COV=true rspec --tag integration` to run the dev-friendly integration tests without coverage. There is only one test because it is meant to provide an hint on how integration tests can be done with rspec instead of cucumber.

- `cucumber` to run the acceptance tests

- `robot_app.sh` to run the application from the command line

### Notes
--------
The project folder contains the tmp folder used for temporary files generated while running tests.

The application can be executed manually using the shell script `robot_app.sh` provided in the main folder.

At this stage the application accepts commands via command line and one after another. Adding a file as input parameter should be farly easy given the command line gem used in the project: see the main application class.

The set of the commands has been extended a little bit adding the `EXIT` command to gently terminate the execution (and make the acceptance tests easier to implement).

The test data are directly in the acceptance tests.
