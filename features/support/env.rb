require 'open3'
require 'aruba/cucumber'
require_relative '../../robot_app/application'
require_relative 'cucumber_helper.rb'

Aruba.configure do |config|
  # config.before_cmd do |cmd|
  #   puts "About to run '#{cmd}'"
  # end
end

# Example of a Before block
# Before('@slow_process') do
#   @aruba_io_wait_seconds = 5
# end

def kill_app_process
  Process.kill 'INT', @wait_thr[:pid] if @wait_thr
end

After do |scenario|
  puts "Standard Error: #{@app_stderr.readlines}" if @app_stderr
  puts "Standard Output: #{@app_stdout.readlines}" if @app_stdout
  @app_stdin = @app_stdout = @app_stderr = @wait_thr = nil
end
