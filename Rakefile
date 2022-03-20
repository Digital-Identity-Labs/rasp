require 'tempfile'

repo1 = "ghcr.io/digital-identity-labs/rasp"
repo2 = "digitalidentity/rasp"
snapshot_name = "rasp:snapshot"
full_version = File.read("VERSION").to_s.strip

task :default => :refresh

task :refresh => [:build]

desc "Rebuild the image"
task :rebuild => [:force_reset, :build]

desc "Build and tag the images (local architecture only)"
task :build do

  tmp_file = Tempfile.new("docker")
  git_hash = `git rev-parse --short HEAD`

  rebuild_or_not = ENV["RASP_FORCE_REBUILD"] ? "--pull --force-rm" : ""

  sh [
       "docker build --iidfile #{tmp_file.path}",
       "--label 'version=#{full_version}'",
       "--label 'org.opencontainers.image.revision=#{git_hash}'",
       rebuild_or_not,
       "./"
     ].join(" ")

  image_id = File.read(tmp_file.path).to_s.strip

  sh "docker tag #{image_id} #{repo1}:#{full_version}"
  sh "docker tag #{image_id} #{repo1}:latest"
  sh "docker tag #{image_id} #{repo2}:#{full_version}"
  sh "docker tag #{image_id} #{repo2}:latest"
  sh "docker tag #{image_id} #{snapshot_name}"

end

task :shell => [:build] do
  sh "docker run --rm -d #{snapshot_name}"
  container_id = `docker ps -q -l`.chomp
  sh "docker exec -it #{container_id} /bin/bash"
end

desc "Rebuild and publish all Docker images to Github and Dockerhub, for multiple architectures"
task publish: ["build"] do

  sh "docker buildx build --platform linux/amd64,linux/arm64 -t #{repo1}:#{full_version} --push ."
  sh "docker buildx build --platform linux/amd64,linux/arm64 -t #{repo1}:latest --push ."
  sh "docker buildx build --platform linux/amd64,linux/arm64 -t #{repo2}:#{full_version} --push ."
  sh "docker buildx build --platform linux/amd64,linux/arm64 -t #{repo2}:latest --push ."

end

task :force_reset do
  ENV["RASP_FORCE_REBUILD"] = "yes"
end

task spec: ["build"] do

  sh "bundle exec rspec spec/rasp/*_spec.rb"

end
