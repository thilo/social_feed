require File.dirname(__FILE__) + '/../spec_helper'
require PLUGIN_ROOT + '/lib/feed_event'

describe FeedEvent, 'send emails' do
  class TestFeedEvent < FeedEvent; end
  
  it "should send no email if mailer does not support it" do
    user = mock_model(User, :subscribed_to_feed_event? => true)
    event = TestFeedEvent.new :source => user, :user => user
    FeedEventMailer.should_receive(:deliver_test_feed_event).never
    event.save!
  end

  it "should derive mailer method from class name" do
    FeedEventMailer.stub!(:send).with(:new).and_return(stub('mailer', :test_feed => true))
    user = mock_model User, :subscribed_to_feed_event? => true, :subscribed_to_email? => true, :online? => false
    event = TestFeedEvent.new :source => user, :user => user
    FeedEventMailer.should_receive(:send).with('deliver_test_feed', event)
    event.save!
  end
  
  it "should not be able to send mail if mailer has no mailer method" do
    TestFeedEvent.can_send_email?.should be_false
  end
  
  it "should be able to send mail if mailer has mailer method" do
    FeedEventMailer.stub!(:new).and_return(nil) # actionmailer.new really returns nil, you have to use send(:new)
    FeedEventMailer.stub!(:send).with(:new).and_return(stub('mailer', :test_feed => true))
    TestFeedEvent.can_send_email?.should be_true
  end
end

describe FeedEvent, 'check event enabled when creating' do
  
  class TestFeedEvent < FeedEvent
    privacy_description 'desc'
  end
  class NotDisabableEvent < FeedEvent; end
  
  before(:each) do
    @user = mock_model User, :feed_event_enabled? => true
    @event  = TestFeedEvent.new :source => mock_model(FeedEvent, :user => @user)
  end
  
  it "should be valid if source user has event enabled" do
    @event.valid?
    @event.should have(:no).errors_on(:source)
  end
  
  it "should be invalid if soure user has event disabled" do
    @user.stub!(:feed_event_enabled?).and_return(false)
    @event.valid?
    @event.should have(1).error_on(:source)
  end
  
  it "should check wether the event is enabled" do
    @user.should_receive(:feed_event_enabled?).with(TestFeedEvent)
    @event.valid?
  end
  
  it "should be valid if source has no user" do
    @event.source = mock_model(FeedEvent)
    @event.valid?
    @event.should have(:no).errors_on(:source)
  end
  
  it "should be valid if source user is nil" do
    @event.source = mock_model(FeedEvent, :user => nil)
    @event.valid?
    @event.should have(:no).errors_on(:source)
  end
  
  it "should be valid if source user has event disabled but event has no privacy description (user can not disabled the event)" do
    @user.stub!(:feed_event_enabled?).and_return(false)
    event = NotDisabableEvent.new :source => mock_model(FeedEvent, :user => @user)
    event.valid?
    event.should have(:no).errors_on(:source)
  end
  
end

describe 'check event enabled when sending email' do
  class TestFeedEvent < FeedEvent
    privacy_description 'desc'
  end
    
  class NotDisabableEvent < FeedEvent;end
  
  class Source; end
  
  before(:each) do
    TestFeedEvent.connection.stub!(:insert)
    FeedEventMailer.stub!(:send).with(:new).and_return(stub('mailer', :test_feed => true, :not_disabable => true))
    @user = mock_model(User, :subscribed_to_feed_event? => true, :subscribed_to_email? => true)
    Source.stub!(:base_class).and_return(Source)
    @source = mock_model(Source, :user => @user)
    @event = TestFeedEvent.new :source => @source, :user => @user
  end

  it "should send no email if event disabled" do
    @user.stub!(:feed_event_enabled?).and_return(false)
    FeedEventMailer.should_receive(:send).with('deliver_test_feed', @event).never
    @event.save
  end
  
  it "should send email if event enabled" do
    @user.stub!(:feed_event_enabled?).and_return(true)
    FeedEventMailer.should_receive(:send).with('deliver_test_feed', @event)
    @event.save
  end
  
  it "should send email if user can't disable event" do
    event = NotDisabableEvent.new :source => @source, :user => @user
    FeedEventMailer.should_receive(:send).with('deliver_not_disabable', event)
    event.save
  end
end
describe FeedEvent, 'check subscriptions when creating' do
  class TestFeedEvent < FeedEvent
    subscribe_description 'desc'
  end
  class NotSubscribableEvent < FeedEvent; end
  
  before(:each) do
    @user = mock_model User
    @event = TestFeedEvent.new :user => @user
  end
  
  it "should be invalid if user not subscribed to event" do
    @user.stub!(:subscribed_to_feed_event?).and_return(false)
    @event.valid?
    @event.should have(1).errors_on(:user)
  end
  
  it "should be valid if user not subscribed to event but event has no description (user could not unsubscribe from this event)" do
    @user.stub!(:subscribed_to_feed_event?).and_return(false)
    @event = NotSubscribableEvent.new :user => @user
    @event.should have(:no).errors_on(:user)
  end
  
  it "should check the subscription of the user" do
    @user.should_receive(:subscribed_to_feed_event?).with(TestFeedEvent).and_return(true)
    @event.valid?
  end
  
  it "should be valid if user subscribed to event" do
    @user.stub!(:subscribed_to_feed_event?).and_return(true)
    @event.valid?
    @event.should have(:no).errors_on(:user)
  end
end

describe FeedEvent, 'check subscription before sending emails' do
  class TestFeedEvent < FeedEvent
    subscribe_description 'desc'    
  end
  class NotSubscribableEvent < FeedEvent; end
  
  before(:each) do
    @user = mock_model User, :subscribed_to_email? => true, :subscribed_to_feed_event? => true, :online? => false
    FeedEventMailer.stub!(:send).with(:new).and_return(stub('mailer', :respond_to? => true))
  end
  
  it "should send an email if user subscribed to email" do
    FeedEventMailer.should_receive(:send).with('deliver_test_feed', anything)
    TestFeedEvent.create :user => @user
  end
  
  it "should send no email if user subscribed to email but is online" do
    @user.stub!(:online?).and_return(true)
    FeedEventMailer.should_receive(:send).with('deliver_test_feed', anything).never
    TestFeedEvent.create :user => @user
  end
  
  it "should send an email user user subscribed to email and has no online method" do
    FeedEventMailer.should_receive(:send).with('deliver_test_feed', anything)
    TestFeedEvent.create :user => mock_model(User, :subscribed_to_email? => true, :subscribed_to_feed_event? => false)
  end
  
  it "should check the subscription of the user" do
    @user.should_receive(:subscribed_to_email?).with(TestFeedEvent).and_return(false)
    TestFeedEvent.create :user => @user
  end
  
  it "should send no email if user has not subscribed to email" do
    @user.stub!(:subscribed_to_email?).and_return(false)
    FeedEventMailer.should_receive(:send).with('deliver_test_feed', anything).never
    TestFeedEvent.create :user => @user
  end
  
  it "should send a email if user can't unsubscribe from email (event has no email description)" do
    @user.stub!(:subscribed_to_email?).and_return(false)
    FeedEventMailer.should_receive(:send).with('deliver_not_subscribable', anything)
    NotSubscribableEvent.create :user => @user
  end
  
  it "should send an email if user subscribed to email but not to feed event" do
    @user.stub!(:subscribed_to_feed_event?).and_return(false)
    FeedEventMailer.should_receive(:send).with('deliver_test_feed', anything)
    TestFeedEvent.create :user => @user
  end
end