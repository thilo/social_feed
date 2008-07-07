module SocialFeed
  module UserExtension
    
    def self.included(base)
      base.class_eval do
        serialize :feed_event_subscriptions
        serialize :email_subscriptions
        serialize :enabled_feed_events
        
        has_many :feed_events, :dependent => :destroy, :order => "id DESC"
        has_many :feed_events_as_source, :dependent => :destroy, :as => :source, :class_name => 'FeedEvent'
      end
      
    end
    
    def subscribe_to_feed_event(event_class) 
      self.feed_event_subscriptions ||= []
      self.feed_event_subscriptions |= [event_class.to_s]
    end
    
    def subscribed_to_feed_event?(event_class)
      self.feed_event_subscriptions.if_not_nil?{|s| s.include?(event_class.to_s)}
    end
    
    def unsubscribe_from_feed_event(event_class)
      self.feed_event_subscriptions_will_change!
      self.feed_event_subscriptions.delete event_class.to_s
    end
    
    def subscribe_to_email(event_class) 
      self.email_subscriptions ||= []
      self.email_subscriptions |= [event_class.to_s]
    end
    
    def subscribed_to_email?(event_class)
      self.email_subscriptions.if_not_nil?{|s| s.include?(event_class.to_s)}
    end
    
    def unsubscribe_from_email(event_class)
      self.email_subscriptions_will_change!
      self.email_subscriptions.delete event_class.to_s
    end
    
    def enable_feed_event(event_class)
      self.enabled_feed_events ||= []
      self.enabled_feed_events |= [event_class.to_s]
    end
    
    def disable_feed_event(event_class)
      self.enabled_feed_events_will_change!
      self.enabled_feed_events.delete event_class.to_s
    end
    
    def feed_event_enabled?(event_class)
      self.enabled_feed_events.if_not_nil?{|e| e.include? event_class.to_s}
    end
    
  end
end