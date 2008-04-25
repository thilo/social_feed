resources :feed_events, :collection => {:toggle_subscription => :post, :toggle_email_subscription => :post, :toggle_enabled => :post,
  :settings => :get}