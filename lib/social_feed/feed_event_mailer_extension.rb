module SocialFeed
  module FeedEventMailerExtension
    
    private
    def  create_event_message(subject, event) 
      @subject    = subject
      @body       = {:event => event}
      @recipients = event.user.email
      @from       = SocialFeed::Conf.sender_email
      @sent_on    = Time.now
    end
  
  end
end