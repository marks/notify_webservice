def new_session(call_options,config)
  if call_options['network'].upcase == 'VOICE'
    call_options['token'] = config['tropo']['session']['voice']
    call_options['channel'] = 'VOICE'
  else # text
    call_options['token'] = config['tropo']['session']['text']
    call_options['channel'] = 'TEXT'
  end
  params_string = "?action=create"
  call_options.each {|key,value| params_string << "&"+key+"="+CGI.escape(value.to_s)}
  response = open(config['tropo']['session']['url'] + params_string).read
  xml = REXML::Document.new(response) 
  return xml.root.get_text("success").to_s # => true or false
end

def read_csv(fields,data)
  rows_data = []
  Excelsior::Reader.rows(data) do |row|
    rows_data << Hash[*fields.zip(row).flatten]
  end
  return rows_data
end