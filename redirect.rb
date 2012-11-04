require 'sinatra'
require 'net/http'
require 'uri'
require "base64"

server_ip = UDPSocket.open {|s| s.connect("8.8.8.8", 1); s.addr.last}
# So it turns out this *is* the easiest way to find your IP.  One of them, anyway.  
# Just make a socket connection to somewhere, and look where you went out. 
cancel_url_template = "http://#{server_ip}:4567/callback/"

def getMac(ip)
  begin
    `arp -n #{ip}|awk '/ether/ {print $3}'`.chomp # There's also no sensible  way to do this other than ARP.  It'd be sweet if it were in the HTTP headers. 
  rescue Exception => ex
  puts ex
  "00:00:00:00:00:00"
  end
end

get '/donate/*' do
  response.headers['Cache-Control'] = "no-cache, no-store"
  response.headers['Connection'] = "close" # Without this, too much crazy ensues when redirecting traffic.
  cancel_url = cancel_url_template + params[:splat].first
  erb :index, :locals => {:cancel_url => cancel_url}
end

get '/callback/*' do
  response.headers['Cache-Control'] = "no-cache, no-store"
  response.headers['Connection'] = "close" #ESPECIALLY here. 
  redirect_url = Base64.decode64(params[:splat].first)
  # allow the user and clear their established connections
  system("sudo iptables -t nat -I PREROUTING -m mac --mac-source #{getMac(request.ip)} -j NET") 
  system("sudo /usr/bin/rmtrack #{request.ip}")
  sleep(1)
  erb :callback, :locals => {:redirect_url => redirect_url}
end

get '/*' do
  response.headers['Cache-Control'] = "no-cache, no-store"
  response.headers['Connection'] = "close"
  #Intercept any requests, and make them donate!
  redirect "http://#{server_ip}:4567/donate/#{Base64.encode64(request.url)}"
end


get '/revoke' do
  response.headers['Cache-Control'] = "no-cache, no-store"
  mac = params["mac"]
  redirect_to = params["redirect_to"]
  system("sudo iptables -t nat -D PREROUTING -m mac --mac-source #{mac} -j NET")
  redirect redirect_to

end
