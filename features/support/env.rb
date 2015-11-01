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
  Process.kill 'INT', @wait_thr[:pid] if @wait_thr
end

After do |scenario|
  if scenario.failed?
    puts "Standard Error: #{@app_stderr.readlines}" if @app_stderr
    puts "Standard Output: #{@app_stdout.readlines}" if @app_stdout
  end
  @app_stdin = @app_stdout = @app_stderr = @wait_thr = nil
end
