
get '/' do
  @messages = Message.all
  @calls = Call.all

  erb :index
end


get '/message/new' do 
	response.headers['Access-Control-Allow-Origin'] = "*"

	@number = params[:phone]
	@message = params[:message]

	account_sid = 'AC7a19ff5f4ab5fe7d93e722f8fff9bc3f'
	auth_token = '7d19dc48b3fad97e4b1a001541cb9a5e'
	@client = Twilio::REST::Client.new account_sid, auth_token

	message = @client.account.messages.create(
		:to => @number,
	  :from => "+15104661137",
		:body => @message
	)
	puts message.to
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
  		:to => @phone,
	    :from => "+15104661137",
  		:url => 'http://secure-temple-4125.herokuapp.com/call/message',
      :StatusCallback => 'http://secure-temple-4125.herokuapp.com/call/response',
      :StatusCallbackMethod => 'get',
  		:Record => true
		)
end

post '/call/message' do
  Twilio::TwiML::Response.new do |r|
    r.Say 'What time is it?', :voice => 'man', :loop => 5
    r.Record(:timeout => "20", :transcribe => true)
  end.text
end

get '/call/response' do
  	@call = Call.create(callsid: params[:CallSid], 
  												 to: params[:To], 
  												 from: params[:From], 
  												 record: params[:RecordingUrl]
  												)
    @call.save!
end

get '/call/record' do
  response.headers['Access-Control-Allow-Origin'] = "*"
  @calls = Call.all
  @last_call_record = @calls.last.record
  { record: @last_call_record }.to_json
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