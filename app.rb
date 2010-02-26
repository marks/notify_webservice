require File.expand_path(File.join(File.dirname(__FILE__), 'vendor', 'gems', 'environment'))
Bundler.require_env

class MyApp < Sinatra::Base
  get '/' do
    return_string = "<h2>Woops</h2>"
       return_string += "<p>I think you wanted this route: (examples below)</p>"
       return_string += "<pre>/call/TO/NETWORK/MESSAGE</pre><ul>"
       examples = ["/call/AIM_USER/aim/Hi AIM user","/call/PHONE_NUMBER/voice/Hi. I just rang your phone.","/call/CELL_PHONE_NUMBER/sms/Hello Moto"]
       examples.each{|ex| return_string += "<li><a href='#{ex}'>#{ex}</a></li>"}
       return_string += "</ul>"
     return_string
  end

  # get '/call/:to/:network/:message' do
  #   return new_session(params,config)
  # end

  get '/cvs' do
    "Not implemented yet!"
  end
end