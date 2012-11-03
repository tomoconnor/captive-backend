require 'sinatra'
require 'net/http'
require 'uri'
require 'digest/sha1'

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

get '/*' do
  puts request.inspect
end

get '/callback' do
 mac = getMac(request.ip)
 redirect_to = params["redirect_to"]
 system("sudo iptables -t nat -I PREROUTING -m mac --mac-source #{mac} -j NET")

 redirect redirect_to
end

get '/revoke' do
  mac = params["mac"]
  redirect_to = params["redirect_to"]
  system("sudo iptables -t nat -D PREROUTING -m mac --mac-source #{mac} -j NET")
  redirect redirect_to

end
