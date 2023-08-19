module OmniAuth
  module Strategies
    autoload :Keepa, Rails.root.join('lib', 'omniauth', 'strategies', 'keepa')
  end
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :keepa, ENV["KEEPA_KEY"], ENV["KEEPA_SECRET"], { provider_ignores_state: true, scope: 'public read write' }
end
