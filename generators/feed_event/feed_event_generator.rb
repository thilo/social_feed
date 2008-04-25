class FeedEventGenerator < Rails::Generator::Base 
  
  attr_accessor :event_name
  
  def initialize(runtime_args, runtime_options = {})
    super
    self.event_name = runtime_args[0]
    raise "Usage: script/generate feed_event <event_name>\ne.g. script/generate feed_event user_signed_up\n" unless event_name
  end
  
  def manifest
    record do |r|
      r.template 'event_model.rb.erb', "app/models/events/#{event_name.underscore}_event.rb"
      r.template 'event_hint.html.erb', "app/views/feed_events/_#{event_name.underscore}_hint.html.erb"
      # email template and mailer method
    end
  end
  
end