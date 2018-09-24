Given(/^a robot is available$/) do
  @app_stdin, @app_stdout, @app_stderr, @wait_thr = Open3.popen3 "#{File.expand_path './robot_app.sh'}"
#  sleep 0.3
end

Given(/^I deploy the robot at column "([\d]+)" and row "([\d]+)" facing "([^"]+)"$/) do |row_idx, col_idx, direction|
  step %Q{I run the following commands}, table(%Q{
    | Command | Data                               |
    | Place   | #{row_idx},#{col_idx},#{direction} |
  })
end

When(/^I ask to report the position$/) do
  step %Q{I run the following commands}, table(%Q{
    | Command |
    | Report  |
  })
end
