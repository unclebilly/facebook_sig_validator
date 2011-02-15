require 'digest/md5'

class FacebookSigValidator
  # If the cookie is valid, return true.  If the cookie is out of date or invalid, return false.
  # cookies is a hash
  # app_id is your facebook app id
  # secret is your facebook app secret
  def self.valid_cookie?(cookies, app_id, secret)
    cookie = cookies["fbs_#{app_id}"].gsub(/\"/, "") rescue ''
    pairs = Hash[cookie.split("&").map {|kv| kv.split("=") }]
    str = pairs.keys.sort.collect {|a| a == "sig" ? nil : "#{a}=#{pairs[a]}"}.reject {|a| a.nil?}.join("")
    (Digest::MD5.hexdigest(str + secret) == pairs["sig"]) && (pairs["expires"] == "0" || Time.now.to_i < pairs["expires"].to_i)
  end
end