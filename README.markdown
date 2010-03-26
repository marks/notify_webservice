Notify Web Service to Leverage Tropo/PostageApp Communication Channels
======================================================================

TODO
----
README :)

For now, execute `ruby app.rb` and go to `http://localhost:4567/` to see instructions and example usage. You can also look inside the `app.rb` file for the haml markup for that file.

Sample Tropo Application Use
----------------------------
Use the code below in a Tropo Hosted Scripting application to let the user text a number of seconds to wait before dispatching a call to them. This could be used to request a fake call via text so you can safely excuse yourself from a date, etc. The call is dispatched using a HTTP GET to the `notify_webservice`

Demo: SMS text message "15" to 240-242-7964 to get a phone call to your cell phone in 15 seconds. The call will come from an "Unknown" or no caller-id phone number.

    #SMS: time in seconds to wait
    require "open-uri"
    answer
    if $currentCall.callerID.length == 11
      sleep_time = $currentCall.initialText.to_i
      say "okay, we'll call you in about #{sleep_time} seconds"
      sleep sleep_time
      response = open(URI.encode("http://notifyr.heroku.com/#{$currentCall.callerID}/voice/#{sleep_time} seconds have elapsed")).read
      if response == "false" then say "Sorry, there was a problem. Try again." end
    else
      say "Sorry, this only works if you SMS 240-242-7964"
    end
    hangup