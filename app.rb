%w(rubygems sinatra rest_client json yaml rexml/document excelsior haml helpers.rb).each {|lib| require lib}

CONFIG = YAML::load(File.read('config.yaml'))

get '/' do
  examples = ["/AIM_USER/aim/Hi AIM user","/PHONE_NUMBER/voice/Hi. I just rang your phone.","/CELL_PHONE_NUMBER/sms/Hello Moto","/EMAIL@PROVIDER.COM/email/Hi via email","/EMAIL@PROVIDER.COM/email/Hi via email?subject=hello, this is the subject"]
  haml :index, :locals => {:examples => examples}
end

get '/:to/:network/:message' do
  new_session(params)
end

get '/csv' do
  haml :csv
end

post '/csv/process' do
  success = []
  rows = read_csv(["to","network","message"],params[:file][:tempfile].read)
  rows.each{|row| success << new_session(row.symbolize_keys)}
  if success.include? "false"
    return "false"
  else
    return "true"
  end
end

__END__
@@index
%h1 Hi. 
%h3 Single Request:
%p Use a single HTTP GET request with this general route: (examples follow)
%pre /TO/NETWORK/MESSAGE
%ul
  - examples.each do |ex|
    %li
      %a(href=ex) #{ex}
      %a{:href => ex}= ex
%hr
%h3 Multimodal:
%p
  Or, if you're looking to upload a CSV file, go to
  %a(title=@title href="/csv") /csv to upload a file.
%p You can also HTTP POST a CSV file directly: (three fields: to,network,message)
%pre curl -F "file=@sample.csv" http://localhost:4567/csv/process
%hr
%h3 TODO: Definitions: to, network, message

@@csv
%h1 Upload A CSV File 
%p
  Please make sure your file is formatted correctly.
  %a(href="/") Some instructions here.
%form{:action=>"/csv/process",:method=>'post',:enctype=>"multipart/form-data"}
  %input{:type => "file",:name => "file"}
  %input{:type => "submit",:value => "Process"}