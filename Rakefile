MRUBY_CONFIG=File.expand_path(ENV["MRUBY_CONFIG"] || "build_config.rb")
MRUBY_VERSION=ENV["MRUBY_VERSION"] || "3703aed7ab7c056ef7a58fd8d25b84b59f715dad"

file :mruby do
  sh "git clone --depth=1 git://github.com/mruby/mruby.git"
  Dir.chdir("./mruby") do
    sh "git checkout #{MRUBY_VERSION} || true"
  end
end

desc "compile binary"
task :compile => :mruby do
  sh "cd mruby && MRUBY_CONFIG=#{MRUBY_CONFIG} rake all"
end

desc "test"
task :test => [:mruby, :testenv] do
  sh "redis-server --port 6379 &"
  sh "redis-server --port 6380 --requirepass 'secret' &"
  sh "cd mruby && MRUBY_CONFIG=#{MRUBY_CONFIG} rake all test"
end

desc "cleanup"
task :clean do
  sh "cd mruby && rake deep_clean"
end

task :default => :test
namespace :dev do
  task :docker do
    sh 'docker-compose stop || true'
    sh 'docker-compose up -d'
    sh 'docker exec -it $(docker-compose ps -q unit) /bin/bash'
  end
end

desc 'db setup'
task :db do
  sh 'mysql -uroot -h127.0.0.1 -e "DROP DATABASE msdtest" || true'
  sh 'mysql -uroot -h127.0.0.1 -e "CREATE DATABASE msdtest"'
  sh 'mysql -uroot -h127.0.0.1 msdtest < test/db/schema.sql'
end

desc "set MySQL ENV"
task :testenv do
  ENV['MYSQL_HOST']="localhost"
  ENV['MYSQL_USER']="root"
  ENV['MYSQL_PASSWORD']=""
  ENV['MYSQL_DATABASE']="database"
end
