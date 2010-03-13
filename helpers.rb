def new_session(params)
  case params[:network].downcase
  when 'email'
    new_postage_session(params)
  else # We use Tropo for everything other than email; just add more 'when' statements if you want to add more services (like iPhone Push, etc.)
    new_tropo_session(params)    
  end
end

def new_tropo_session(call_options)
  if call_options[:network].downcase == 'voice'
    call_options['token'] = CONFIG['tropo']['session']['voice']
    call_options['channel'] = 'voice'
  else # a text channel (includes SMS, IM, etc.) if not a voice session
    call_options['token'] = CONFIG['tropo']['session']['text']
    call_options['channel'] = 'text'
  end
  params_string = "?action=create"
  call_options.each {|key,value| params_string << "&"+key.to_s+"="+escape(value.to_s)}
  begin; response = RestClient.get(CONFIG['tropo']['session']['url'] + params_string)
  rescue; return "false"; end;
  return REXML::Document.new(response).root.get_text("success").to_s # => true or false
end

def new_postage_session(variables)
  postage_api = CONFIG['postage']['url']
  postage_url = postage_api + "/send_message.json"
  postage_string = "{
      \"api_key\": #{CONFIG['postage']['key']},
      \"arguments\": {
          \"template\": \"generic\",
          \"recipients\": #{variables[:to].to_json},
          \"variables\": #{variables.to_json},
   				\"headers\": {
              \"from\": \"giveglobally@gmail.com\",
              \"reply-to\": \"giveglobally@gmail.com\" 
          } 
      } 
  }"
  begin; mail_json = JSON.parse(RestClient.post(postage_url, postage_string, :content_type => :json, :accept => :json))
  rescue; return "false"; end
  return "true"
end

def read_csv(fields,data)
  rows_data = []
  Excelsior::Reader.rows(data) do |row|
    rows_data << Hash[*fields.zip(row).flatten]
  end
  return rows_data
end

class Hash
  def symbolize_keys
    inject({}) do |options, (key, value)|
      options[(key.to_sym rescue key) || key] = value
      options
    end
  end
end

class String
  # From stdlib file cgi.rb, line 341
  def escape(string)
    string.gsub(/([^ a-zA-Z0-9_.-]+)/n) do
      '%' + $1.unpack('H2' * $1.size).join('%').upcase
    end.tr(' ', '+')
  end
end