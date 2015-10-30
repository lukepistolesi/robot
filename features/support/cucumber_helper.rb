class CucumberHelper

  def self.submit_command(command, app_stdin)
    app_stdin.puts command
  end

  def self.write_commands_file(commands, input_file)
    input_file.write commands.to_yaml
  end

end
