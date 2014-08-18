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

  #Install Shipyard
  `docker run -t -v /var/run/docker.sock:/docker.sock shipyard/deploy setup`
  `curl https://github.com/shipyard/shipyard-agent/releases/download/v0.3.2/shipyard-agent -L -o /usr/local/bin/shipyard-agent`
  `chmod +x /usr/local/bin/shipyard-agent`

begin
status = Timeout::timeout(20) {
  `aa=$(shipyard-agent -url http://#{app_config[:system_fqdn]}:8000 -register 2>&1 ); key=\`echo ${aa##* }\`; shipyard-agent -url http://#{app_config[:system_fqdn]}:8000 -key $key &`
}
rescue Exception => e
puts 'rescued'
end

uri = URI.parse("http://#{app_config[:system_fqdn]}:8000/api/login")
http = Net::HTTP.new(uri.host, uri.port)
req = Net::HTTP::Post.new(uri.request_uri)
req.set_form_data('username' => 'admin', 'password' => 'shipyard')
response_json = http.request(req)
api_key = JSON.parse(response_json.body)['api_key']


uri = URI.parse("http://#{app_config[:system_fqdn]}:8000/api/v1/hosts/1/")
http = Net::HTTP.new(uri.host, uri.port)
req = Net::HTTP::Put.new(uri.request_uri)
req.add_field("Authorization", "ApiKey admin:#{api_key}")
req.add_field("Content-Type", "application/json")
#req.set_form_data('{"enabled": true}')
#req.set_form_data('enabled' => false)
req.body = {:enabled => true}.to_json
response = http.request(req)

puts response.code

  File.unlink("/etc/nginx/sites-available/default")

  new_config = ERB.new(File.read("/var/www/default")).result(binding)
  File.open("/etc/nginx/sites-available/default", "w"){|file| file.write(new_config) }

  `/etc/init.d/nginx restart`

  #Uninstall unwanted apps
#  `apt-get remove -y mysql-server mysql-server-core-5.5 phpmyadmin`
#  `apt-get -y autoremove`

  #File.unlink("/var/www/Rakefile")

end
