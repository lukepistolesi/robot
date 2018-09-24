class IntegrationHelper

  def self.run_application_with_commands(commands)
    app_stdin, app_stdout, app_stderr, wait_thr = Open3.popen3 "#{File.expand_path './robot_app.sh'}"

    commands.each { |command| app_stdin.puts command }

    # sleep 0.3
    begin
      Process.kill 'INT', wait_thr[:pid]
    rescue Exception => ex
      puts "Could not kill the process: #{ex.message}"
      puts "STD ERR:\n#{app_stderr.readlines.map(&:strip).join "\n"}"
    end

    app_stdout.readlines.map &:strip
  end

end
