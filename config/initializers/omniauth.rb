Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, '2Uc4DDHYO5Pat5mEI50FNQ', 'zKZZdlqXVed9a3D9gk6zVB5IfXCD0Kfb7woU5vNAmw'
  provider :facebook, '1375132849374294', '7d6a7dd14752f9ddf339ba8742cf53a8',{:scope => 'publish_stream,offline_access,email'}
end
