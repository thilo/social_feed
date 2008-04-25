module SocialFeed
  module FeedEventsControllerExtension
    
    def destroy
      @event = current_user.feed_events.find params[:id]
      @event.destroy
    end
    
    def index
      @feed_events = current_user.feed_events.find :all, :limit => 20, :order => 'created_at DESC'
    end
    
    def settings
      
    end
    
    def toggle_subscription
      if current_user.subscribed_to_feed_event?(params[:event])
        current_user.unsubscribe_from_feed_event(params[:event])
      else
        current_user.subscribe_to_feed_event(params[:event])
      end
      current_user.save
      render :nothing => true
    end
    
    def toggle_email_subscription
      if current_user.subscribed_to_email?(params[:event])
        current_user.unsubscribe_from_email(params[:event])
      else
        current_user.subscribe_to_email(params[:event])
      end
      current_user.save
      render :nothing => true
    end
    
    def toggle_enabled
      if current_user.feed_event_enabled? params[:event]
        current_user.disable_feed_event params[:event]
      else
        current_user.enable_feed_event params[:event]
      end
      current_user.save
      render :nothing => true    
    end
    
  end
end