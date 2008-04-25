module SocialFeed
  module FeedEventMailerExtension
    
    private
    def  create_event_message(subject, event) 
      @subject    = subject
      @body       = {:event => event}
      @recipients = event.user.email
      @from       = SocialFeedConf.sender_email
      @sent_on    = Time.now
    end
  
  end
end