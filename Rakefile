require 'rubygems'
require 'fileutils'
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
  system_fqdn = metadata['fqdn']
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

  `/etc/init.d/nginx stop`

  #Install Shipyard
  `docker run -i -t -v /var/run/docker.sock:/docker.sock shipyard/deploy setup`
  `curl https://github.com/shipyard/shipyard-agent/releases/download/v0.3.2/shipyard-agent -L -o /usr/local/bin/shipyard-agent`
  `chmod +x /usr/local/bin/shipyard-agent`
  `aa=$(shipyard-agent -url http://#{app_config[:system_fqdn]}:8000 -register 2>&1 ); key=\`echo ${aa##* }\`; shipyard-agent -url http://#{app_config[:system_fqdn]}:8000 -key $key &`

  #Uninstall unwanted apps
#  `apt-get remove -y mysql-server mysql-server-core-5.5 phpmyadmin`
#  `apt-get -y autoremove`

  #File.unlink("/var/www/Rakefile")

end
