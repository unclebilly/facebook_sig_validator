require 'helper'

class TestFacebookSigValidator < Test::Unit::TestCase
  def test_valid_signature
    app_secret = "OMGOMGOMG"
    app_id = "123123"
    
    access_token = '141099679280355%7C2.V6Cm2wWhy0ATucuZVgQBWQ__.3600.1297807200-1104597451%7C9CqJGZ4IaMgvIBQHK_HF0yA1jjU'
    expires = Time.now.to_i + 7000
    secret = 'nPGWG5m_14m8wOy6_ZEu3g__'
    session_key = '2.V6Cm2wWhy0ATucuZVgQBWQ__.3600.1297807200-1104597451'
    uid = '1104597451'
    sig = 'f1a41ebc69e96487e87219b60c942c96'
    
    sum_str = "access_token=#{access_token}expires=#{expires}secret=#{secret}session_key=#{session_key}uid=#{uid}#{app_secret}"
    sum = Digest::MD5.hexdigest(sum_str)

    cookies = {"fbs_#{app_id}" => "access_token=#{access_token}" + 
                                  "&expires=#{expires}" + 
                                  "&secret=#{secret}" + 
                                  "&session_key=#{session_key}" +
                                  "&sig=#{sum}" +
                                  "&uid=#{uid}" }

    assert(FacebookSigValidator.valid_cookie?(cookies, app_id, app_secret))                              
  end
  
  def test_signature_too_old
    app_secret = "OMGOMGOMG"
    app_id = "123123"
    
    access_token = '141099679280355%7C2.V6Cm2wWhy0ATucuZVgQBWQ__.3600.1297807200-1104597451%7C9CqJGZ4IaMgvIBQHK_HF0yA1jjU'
    expires = Time.now.to_i - 7000
    secret = 'nPGWG5m_14m8wOy6_ZEu3g__'
    session_key = '2.V6Cm2wWhy0ATucuZVgQBWQ__.3600.1297807200-1104597451'
    uid = '1104597451'
    sig = 'f1a41ebc69e96487e87219b60c942c96'
    
    sum_str = "access_token=#{access_token}expires=#{expires}secret=#{secret}session_key=#{session_key}uid=#{uid}#{app_secret}"
    sum = Digest::MD5.hexdigest(sum_str)

    cookies = {"fbs_#{app_id}" => "access_token=#{access_token}" + 
                                  "&expires=#{expires}" + 
                                  "&secret=#{secret}" + 
                                  "&session_key=#{session_key}" +
                                  "&sig=#{sum}" +
                                  "&uid=#{uid}" }

    assert(!FacebookSigValidator.valid_cookie?(cookies, app_id, app_secret))
  end
  
  def test_signature_incorrect
    app_secret = "OMGOMGOMG"
    app_id = "123123"
    
    access_token = '141099679280355%7C2.V6Cm2wWhy0ATucuZVgQBWQ__.3600.1297807200-1104597451%7C9CqJGZ4IaMgvIBQHK_HF0yA1jjU'
    expires = Time.now.to_i + 7000
    secret = 'nPGWG5m_14m8wOy6_ZEu3g__'
    session_key = '2.V6Cm2wWhy0ATucuZVgQBWQ__.3600.1297807200-1104597451'
    uid = '1104597451'
    sig = 'f1a41ebc69e96487e87219b60c942c96'
    
    sum_str = "access_token=#{access_token}expires=#{expires}secret=#{secret}session_key=#{session_key}uid=#{uid}#{app_secret}"
    sum = Digest::MD5.hexdigest(sum_str)

    cookies = {"fbs_#{app_id}" => "access_token=#{access_token}" + 
                                  "&expires=#{expires}" + 
                                  "&secret=#{secret.gsub(/P/,'p')}" + 
                                  "&session_key=#{session_key}" +
                                  "&sig=#{sum}" +
                                  "&uid=#{uid}" }

    assert(!FacebookSigValidator.valid_cookie?(cookies, app_id, app_secret))
  end
  
  def test_no_cookie
    app_secret = "OMGOMGOMG"
    app_id = "123123"
    
    assert(!FacebookSigValidator.valid_cookie?({}, app_id, app_secret))
  end
end
