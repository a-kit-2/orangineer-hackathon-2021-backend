if Rails.env === 'production'
  Rails.application.config.session_store :cookie_store, key: '_orangineer-2021-backend', domain: 'https://'
else
  Rails.application.config.session_store :cookie_store, key: '_orangineer-2021-backend'
end