require 'sinatra'
require 'net/http'
require 'uri'
require "base64"

server_ip = UDPSocket.open {|s| s.connect("64.233.187.99", 1); s.addr.last}
cancel_url_template = "http://#{server_ip}:4567/callback/"

def getMac(ip)
  begin
    `arp -n #{ip}|awk '/ether/ {print $3}'`.chomp
  rescue Exception => ex
  puts ex
  "00:00:00:00:00:00"
  end
end

get '/donate/*' do
  cancel_url = cancel_url_template + params[:splat].first
  erb :index, :locals => {:cancel_url => cancel_url}
end

get '/callback/*' do
  redirect_url = "#{Base64.decode64(params[:splat].first)}?#{Time.now.to_i}"
  system("sudo iptables -t nat -I PREROUTING -m mac --mac-source #{getMac(request.ip)} -j NET")

  erb :callback, :locals => {:redirect_url => redirect_url}
end

get '/*' do
  redirect "http://#{server_ip}:4567/donate/#{Base64.encode64(request.url)}"
end


get '/revoke' do
  mac = params["mac"]
  redirect_to = params["redirect_to"]
  system("sudo iptables -t nat -D PREROUTING -m mac --mac-source #{mac} -j NET")
  redirect redirect_to

end
