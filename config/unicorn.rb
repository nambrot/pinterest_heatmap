worker_processes 4
timeout 30
listen "/tmp/unicorn.blog.sock"
 
root = "/home/azureuser/apps/pinterest_heatmap/current"
 
working_directory root
 
pid "#{root}/tmp/pids/unicorn.pid"
stderr_path "#{root}/log/unicorn.log"
stdout_path "#{root}/log/unicorn.log"

@resque_pid = nil
@resque_pid2 = nil
@resque_pid3 = nil

before_fork do |server, worker|
  # @resque_pid ||= spawn("bundle exec rake jobs:work")
  # @resque_pid2 ||= spawn("bundle exec rake jobs:work")
  # @resque_pid3 ||= spawn("bundle exec rake jobs:work")
end
