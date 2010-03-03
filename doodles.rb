# http://api.tropo.com/1.0/sessions?action=create&token=e360244f4526cf439418f7bc71500f09c6c1e688c65d08a38866f913d36991432ce4d7f609d94be7c82f6acd&to=SkramX&network=aim&channel=text&message=Hi+AIM+user
require 'rubygems'
require 'pp'
require 'rest_client'
response = RestClient.get("http://api.tropo.com/1.0/sessions?action=create&token=e360244f4526cf439418f7bc71500f09c6c1e688c65d08a38866f913d36991432ce4d7f609d94be7c82f6acd&to=SkramX&network=aim&channel=text&message=Hi+AIM+user",:content_type => :json, :accept => :json)
pp response