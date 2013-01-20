
if Rails.env.development? || Rails.env.test?
  Instagram.configure do |config|
    config.client_id = '2523ac2b07ae4bb2a76b4c633f156969'
    config.client_secret = '73c55b3cb5d24bedbb2666256dc04da3'
  end
else
  Instagram.configure do |config|
    config.client_id = 'c0db2245ea5e4b09a58f81ec96e53fc0'
    config.client_secret = '02c9ab5474004b95aebf65ddb8383e37'
  end
end
