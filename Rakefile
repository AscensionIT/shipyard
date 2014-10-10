require 'rubygems'
require 'fileutils'
require 'timeout'
require 'erb'
require 'tempfile'
require 'securerandom'
require 'json'
require "net/http"
require "uri"

task :install do
  dbhost = '127.0.0.1'
  app_config = {}

  # Read app user from METADATA
  metadata = JSON.parse(File.read("/opt/durga/meta.json"))
  dbuser = 'root'
  dbpassword = metadata['dbinfo']['dbpass']
  dbname = metadata['dbinfo']['dbname']
  system_fqdn = metadata['host']
  app_config[:system_fqdn] = system_fqdn
  
  app_config[:username] = metadata['username']
  app_config[:firstname] = metadata['firstname']
  app_config[:lastname] = metadata['lastname']
  app_config[:title] = metadata['title']
  app_config[:displayname] = metadata['displayname']
  app_config[:title] = metadata['title']
  app_config[:clientname] = metadata['clientname']
  app_config[:streetaddress] = metadata['streetaddress']
  app_config[:state] = metadata['state']
  app_config[:city] = metadata['city']
  app_config[:zip] = metadata['zip']
  app_config[:country] = metadata['country']
  app_config[:phone] = metadata['phone']
  app_config[:fax] = metadata['fax']

  #Uninstall unwanted apps
  `DEBIAN_FRONTEND=noninteractive apt-get remove -q -y mysql-server mysql-server-core-5.5 phpmyadmin nginx php5-fpm`
  `DEBIAN_FRONTEND=noninteractive apt-get -q -y autoremove`

  #Install Shipyard
  `docker run -it -d --name shipyard-rethinkdb-data --entrypoint /bin/bash shipyard/rethinkdb -l`
  `docker run -it -P -d --name shipyard-rethinkdb --volumes-from shipyard-rethinkdb-data shipyard/rethinkdb`
  `docker run -it -p 80:8080 -d --name shipyard -v /var/run/docker.sock:/docker.sock --link shipyard-rethinkdb:rethinkdb shipyard/shipyard`

  #Give about 20sec
  sleep(20)


  http = Net::HTTP.new("127.0.0.1", 80)
  request = Net::HTTP::Post.new("/auth/login")
  request.body = '{"password":"shipyard","username":"admin"}'
  response = http.request(request)
  admin_token = JSON.parse(response.body)['auth_token']

  request = Net::HTTP::Post.new("/api/engines")
  request.add_field('X-Access-Token', "admin:#{admin_token}")
  cpus = `cat /proc/cpuinfo | grep processor | wc -l`.to_i
  mem = (`cat /proc/meminfo  |grep MemTotal |awk '{ print $2 }'`.to_i / 1024).to_i
  request.body = '{"id": "local","ssl_cert": "","ssl_key": "","ca_cert": "",'\
    '"engine": {"id": "local","addr": "unix:///docker.sock","cpus": ' + 
    cpus.to_s + ',"memory": ' + mem.to_s + ',"labels": ["local","dev"]}}'
  response = http.request(request)

  request = Net::HTTP::Post.new("/api/accounts")
  request.add_field('X-Access-Token', "admin:#{admin_token}")
  request.body = '{"username":"' + app_config[:username].to_s + '", "password":"password","role":{"name":"admin"}}'
  response = http.request(request)

  request = Net::HTTP::Delete.new("/api/accounts")
  request.add_field('X-Access-Token', "admin:#{admin_token}")
  request.body = '{"username":"admin"}'
  response = http.request(request)


  File.unlink("/var/www/Rakefile")

end
