Given(/^the final position is row "([\d]+)" and column "([\d]+)" facing "([^"]+)"$/) do |row_idx, col_idx, direction|
  #kill the process to unlock all the std pipes: easy way
  kill_app_process
  lines = @app_stdout.readlines || []
  last_line = lines.empty? ? '' : lines.last.strip

  expected_output = "#{row_idx},#{col_idx},#{direction}"

  if last_line != expected_output
    puts "STD OUT:\n#{lines.join "\n"}"
    puts "STD ERR:\n#{@app_stderr.readlines.map(&:strip).join "\n"}"
    expect(last_line).to eql expected_output
  end

end
