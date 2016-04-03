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

  #Install Docker
  `apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D`
  `echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list`
  `DEBIAN_FRONTEND=noninteractive apt-get update`
  `DEBIAN_FRONTEND=noninteractive apt-get install -y docker-engine`
  `service docker start`
  
  #Uninstall unwanted apps
  `DEBIAN_FRONTEND=noninteractive apt-get remove -q -y mysql-server apache2`
  `DEBIAN_FRONTEND=noninteractive apt-get -q -y autoremove`

  #Install Shipyard
  `curl -sSL https://shipyard-project.com/deploy | bash -s`


  File.unlink("/var/www/Rakefile")

end
