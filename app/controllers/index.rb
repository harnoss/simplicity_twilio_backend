
get '/' do
  @messages = Message.all
  @calls = Call.all

  erb :index
end


get '/message/new' do 
	response.headers['Access-Control-Allow-Origin'] = "*"

	@phone_numbers = params[:phone]
	@message = params[:message]

	account_sid = 'AC7a19ff5f4ab5fe7d93e722f8fff9bc3f'
	auth_token = '7d19dc48b3fad97e4b1a001541cb9a5e'
	@client = Twilio::REST::Client.new account_sid, auth_token

	@phone_numbers.each do |number|
		message = @client.account.messages.create(
			:to => number,
	    :from => "+15104661137",
			:body => @message,
	    )
	puts message.to
	end
end

get '/message/response' do
  @message = Message.create(messagesid: params[:MessageSid], 
  													to: params[:To], 
  													from: params[:From], 
  													text: params[:Body]
  													)
  @message.save!

  twiml = Twilio::TwiML::Response.new do |r|
    r.Message "Thank you, that was nice, indeed!"
  end
  twiml.text
end

get '/call/new' do
	response.headers['Access-Control-Allow-Origin'] = "*"

	@phone = params[:phone]

	account_sid = 'AC7a19ff5f4ab5fe7d93e722f8fff9bc3f'
	auth_token = '7d19dc48b3fad97e4b1a001541cb9a5e'
	@client = Twilio::REST::Client.new account_sid, auth_token

	@call = @client.account.calls.create(
  		:to => '+15105081935',
	    :from => "+15104661137",
	    #:ApplicationSid => 'PNe1dcc8f2ffa1d1912fd7b9399c0ea49a',
  		#:url => 'http://dry-fortress-5128.herokuapp.com/call/response',
      #:url => 'http://twimlets.com/holdmusic?Bucket=com.twilio.music.ambient',
  		:url => 'http://secure-temple-4125.herokuapp.com/call/message',
  		#:method => "GET",
  		#:ApplicationSid => 'AP7c4573a2127b25eb675bede58759da0f'
      	:StatusCallback => 'http://secure-temple-4125.herokuapp.com/call/response',
      	:StatusCallbackMethod => 'get',
  		:Record => true
		)
end

post '/call/message' do
  #  '<?xml version="1.0" encoding="UTF-8"?>
  #    <Response>
  #      <Say voice="woman">Please leave a message after the tone.</Say>
  #      <Record maxLength="20" />
  #    </Response>'

  Twilio::TwiML::Response.new do |r|
    r.Say "What time is it?"
  #  r.Play 'http://demo.twilio.com/hellomonkey/monkey.mp3'
  end
  puts response.text
  #p 'works too'
end

get '/call/response' do
  	@message = Call.create(callsid: params[:CallSid], 
  												 to: params[:To], 
  												 from: params[:From], 
  												 record: params[:RecordingUrl]
  												)
    @message.save!
end


  
# Get your Account Sid and Auth Token from twilio.com/user/account



# Get an object from its sid. If you do not have a sid,
# check out the list resource examples on this page

#@number = @client.account.incoming_phone_numbers.get("PN2e6d0812c4bae854bf8b42ab150f58c0")
#puts @number.phone_number
#
#@client.account.messages.list(
#	:to => @number.phone_number
#	#:from => "+15105081935"
#	)
#	.each do |message|
#    puts message.body
#end

#@message = @client.account.messages.get("PN2e6d0812c4bae854bf8b42ab150f58c0")
#puts @message.body


#JS module
#
#ajax request to 
#	post '/messages/new'
#	with phone number and name and message
#	callback to and from
#
#ajax request to get 'response' with to and from
#	take the last one in the db
#	callback with that data point, body
#
#what triggers that ajax request?