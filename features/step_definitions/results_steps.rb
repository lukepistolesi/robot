Given(/^the final position is row "([\d]+)" and column "([\d]+)" facing "([^"]+)"$/) do |row_idx, col_idx, direction|
  #kill the process to unlock all the std pipes: easy way
  kill_app_process
  expect(@app_stdout.readlines.last.strip).to eql "Output: #{row_idx},#{col_idx},#{direction}"
end
