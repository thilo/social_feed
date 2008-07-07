require File.dirname(__FILE__) + '/../spec_helper'

describe User, 'enable feed events' do
  
  class TestEvent; end
  before(:each) do
    @user = User.new
  end
  
  it "should enable an event" do
    @user.enable_feed_event TestEvent
    @user.enabled_feed_events.should include('TestEvent')
  end
  
  it "should enable an event only once" do
    @user.enable_feed_event TestEvent
    @user.enable_feed_event TestEvent
    @user.enabled_feed_events.should == ['TestEvent']
  end
  
  it "should disable and event" do
    @user.enabled_feed_events = ['TestEvent']
    @user.disable_feed_event TestEvent
    @user.enabled_feed_events.should_not include('TestEvent')
  end
  
  it "should return true if an event is enabled" do
    @user.enabled_feed_events = ['TestEvent']
    @user.should be_feed_event_enabled(TestEvent)
  end
  
  it "should return false if an event is disabled" do
    @user.should_not be_feed_event_enabled(TestEvent)
  end
  
  it "should mark the attibute dirty when disabling" do
    @user.enabled_feed_events = ['TestEvent']
    @user.save!
    @user.disable_feed_event TestEvent
    @user.should be_enabled_feed_events_changed
  end
  
  it "should mark the attibute dirty when enabling" do
    @user.enabled_feed_events = ['TestEvent1']
    @user.save!
    @user.enable_feed_event TestEvent
    @user.should be_enabled_feed_events_changed
  end
end

describe User, 'subscribe to feed events' do
  class TestEvent; end
  before(:each) do
    @user = User.new
  end

  it "should subscribe to an event" do
    @user.subscribe_to_feed_event TestEvent
    @user.feed_event_subscriptions.should include('TestEvent')
  end
  
  it "should subscribe to an event only once" do
    @user.subscribe_to_feed_event TestEvent
    @user.subscribe_to_feed_event TestEvent
    @user.feed_event_subscriptions.should == ['TestEvent']
  end
  
  it "should unsubscribe from an event" do
    @user.feed_event_subscriptions = ['TestEvent']
    @user.unsubscribe_from_feed_event TestEvent
    @user.feed_event_subscriptions.should be_empty 
  end
  
  it "should return true if user is subscribed" do
    @user.feed_event_subscriptions = ['TestEvent']
    @user.should be_subscribed_to_feed_event(TestEvent)
  end
  
  it "should return false if user is not subscribed" do
    @user.should_not be_subscribed_to_feed_event(TestEvent)
  end
  
  it "should mark the attibute dirty when subscribing" do
    @user.feed_event_subscriptions = ['TestEvent1']
    @user.save!
    @user.subscribe_to_feed_event TestEvent
    @user.should be_feed_event_subscriptions_changed
  end
  
  it "should mark the attibute dirty when unsubscribing" do
    @user.feed_event_subscriptions = ['TestEvent']
    @user.save!
    @user.unsubscribe_from_feed_event TestEvent
    @user.should be_feed_event_subscriptions_changed
  end
  
end

describe User, 'subscribe to emails' do
  class TestEvent; end
  before(:each) do
    @user = User.new
  end

  it "should subscribe to an email" do
    @user.subscribe_to_email TestEvent
    @user.email_subscriptions.should include('TestEvent')
  end
  
  it "should subscribe to an email only once" do
    @user.subscribe_to_email TestEvent
    @user.subscribe_to_email TestEvent
    @user.email_subscriptions.should == ['TestEvent']
  end
  
  it "should unsubscribe from an email" do
    @user.email_subscriptions = ['TestEvent']
    @user.unsubscribe_from_email TestEvent
    @user.email_subscriptions.should be_empty 
  end
  
  it "should return true if user is subscribed" do
    @user.email_subscriptions = ['TestEvent']
    @user.should be_subscribed_to_email(TestEvent)
  end
  
  it "should return false if user is not subscribed" do
    @user.should_not be_subscribed_to_email(TestEvent)
  end
  
  it "should mark the attibute dirty when subscribing" do
    @user.email_subscriptions = ['TestEvent1']
    @user.save!
    @user.subscribe_to_email TestEvent
    @user.should be_email_subscriptions_changed
  end
  
  it "should mark the attibute dirty when unsubscribing" do
    @user.email_subscriptions = ['TestEvent']
    @user.save!
    @user.unsubscribe_from_email TestEvent
    @user.should be_email_subscriptions_changed
  end
end


describe User, 'subscribed to email notification' do
end