Given(/^the final position is column "([\d]+)" and row "([\d]+)" facing "([^"]+)"$/) do |row_idx, col_idx, direction|
  #kill the process to unlock all the std pipes: easy way
  kill_app_process
  lines = @app_stdout.readlines || []
  last_line = lines.empty? ? '' : lines.last.strip

  expected_output = "#{row_idx},#{col_idx},#{direction}"

  if last_line != expected_output
    print_std_out_and_err lines
    expect(last_line).to eql expected_output
  end

end

Given(/^the application output is "([^"]+)"$/) do |robot_status|
  #kill the process to unlock all the std pipes: easy way
  kill_app_process
  lines = @app_stdout.readlines || []
  last_line = lines.empty? ? '' : lines.last.strip

  unless last_line.include? robot_status
    print_std_out_and_err lines
    expect(last_line).to eql robot_status
  end

end

def print_std_out_and_err(std_out_lines)
  puts "STD OUT:\n#{std_out_lines.join "\n"}"
  puts "STD ERR:\n#{@app_stderr.readlines.map(&:strip).join "\n"}"
end
