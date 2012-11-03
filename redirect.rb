require 'sinatra'
require 'net/http'
require 'uri'

serverurl = "http://posttestserver.com/post.php"
serverurl = "http://charity-wifi.cgb.im/test"


def getMac(ip)
  begin
    `arp -n #{ip}|awk '/ether/ {print $3}'`.chomp
  rescue Exception => ex
  puts ex
  "00:00:00:00:00:00"
  end
end

get '/' do
  mac = getMac(request.ip)
  "Your IP address is #{request.ip} and your MAC is #{mac}"
  postData = Net::HTTP.post_form(URI.parse(serverurl), 
  {'ip' => request.ip, 'mac' => mac, 'redirect_to' => url('/auth')})
  postData.body
end

post '/auth' do
  pp params
end
