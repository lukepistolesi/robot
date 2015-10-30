Given(/^I run the following commands$/) do |table|

  table.hashes.each do |row|
    command = "#{row['Command']} #{row['Data']}".strip
    begin
      CucumberHelper.submit_command command.upcase, @app_stdin
    rescue Exception => ex
      puts "Standard Error:\n#{@app_stderr.gets}" if @app_stderr
      raise ex
    end
  end

end
