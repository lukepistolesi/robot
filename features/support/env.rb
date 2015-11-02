require 'open3'
require 'aruba/cucumber'
require_relative '../../robot_app/application'
require_relative 'cucumber_helper.rb'

Aruba.configure do |config|
  # config.before_cmd do |cmd|
  #   puts "About to run '#{cmd}'"
  # end
end

def kill_app_process
  @app_stdin.puts 'EXIT'
end

After do |scenario|
  # puts "Standard Output: #{@app_stdout.readlines.join "\n"}" if @app_stdout
  if scenario.failed?
    puts "Standard Error: #{@app_stderr.readlines}" if @app_stderr
    puts "Standard Output: #{@app_stdout.readlines}" if @app_stdout
  end
  @app_stdin = @app_stdout = @app_stderr = @wait_thr = nil
end
