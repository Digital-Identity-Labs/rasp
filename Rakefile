
task :default => :refresh

task :refresh => [:build, :test]

task :build do
  sh "docker build --pull -t digitalidentitylabs/rasp ."
end

task :rebuild do
  sh "docker build --pull --force-rm -t digitalidentitylabs/rasp ."
end

task :test => [:build] do
  begin
    sh "docker run -d -p 8080:8080 digitalidentitylabs/rasp"
    container_id = `docker ps -q -l`
    sleep ENV['CI'] ? 20 : 10
    colour = ENV['CI'] ? "--no-color" : "--color"
    sh "bundle exec inspec exec specs/rasp-internal/ #{colour} -t docker://#{container_id} "
  ensure
    sh "docker stop #{container_id}" if container_id
  end
end
