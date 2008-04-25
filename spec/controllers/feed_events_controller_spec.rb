require File.dirname(__FILE__) + '/../spec_helper'
require PLUGIN_ROOT + '/lib/social_feed/feed_events_controller_extension'

class FeedEventsController
  attr_accessor :params
  include SocialFeed::FeedEventsControllerExtension
  
  def render(options); end
    
end

describe FeedEventsController do

  before(:each) do
    @controller = FeedEventsController.new
  end
  
  def set_current_user(user)
    @controller.stub!(:current_user).and_return(user)
  end
  
  def post(method, options)
    @controller.params = options
    @controller.send method
  end
  

describe FeedEventsController, 'toggle enabled feed events' do
  before(:each) do
    @user = stub 'user', :feed_event_enabled? => false, :enable_feed_event => true, :save => true
    set_current_user @user
  end
  
  it "should enable the event" do
    @user.should_receive(:enable_feed_event).with('TestEvent')
    post :toggle_enabled, :event => 'TestEvent'
  end
  
  it "should disable an enabled event" do
    @user.stub!(:feed_event_enabled?).with('TestEvent').and_return(true)
    @user.should_receive(:disable_feed_event).with('TestEvent')
    post :toggle_enabled, :event => 'TestEvent'
  end
  
  it "should save the user" do
    @user.should_receive(:save)
    post :toggle_enabled, :event => 'TestEvent'
  end
  
end

describe FeedEventsController, 'toggle subscribe to feed event' do
  before(:each) do
    @user = stub 'user', :subscribed_to_feed_event? => true, :unsubscribe_from_feed_event => false, :save => true
    set_current_user @user
  end
  
  it "should subscribe on the event" do
    @user.stub!(:subscribed_to_feed_event?).with('TestEvent').and_return(false)
    @user.should_receive(:subscribe_to_feed_event).with('TestEvent')
    post :toggle_subscription, :event => 'TestEvent'
  end
  
  it "should unsubscribe from a subscribed event" do
    @user.stub!(:subscribed_to_feed_event?).with('TestEvent').and_return(true)
    @user.should_receive(:unsubscribe_from_feed_event).with('TestEvent')
    post :toggle_subscription, :event => 'TestEvent'
  end
  
  it "should save the user" do
    @user.should_receive(:save)
    post :toggle_subscription, :event => 'TestEvent'
  end
  
end

describe FeedEventsController, 'toggle subscribe to email event' do
  before(:each) do
    @user = stub 'user', :subscribed_to_email? => true, :unsubscribe_from_email => nil, :save => true
    set_current_user @user
  end
  

  it "should subscribe on the event" do
    @user.stub!(:subscribed_to_email?).with('TestEvent').and_return(false)
    @user.should_receive(:subscribe_to_email).with('TestEvent')
    post :toggle_email_subscription, :event => 'TestEvent'
  end
  
  it "should unsubscribe from a subscribed event" do
    @user.stub!(:subscribed_to_email?).with('TestEvent').and_return(true)
    @user.should_receive(:unsubscribe_from_email).with('TestEvent')
    post :toggle_email_subscription, :event => 'TestEvent'
  end
  
  it "should save the user" do
    @user.should_receive(:save)
    post :toggle_email_subscription, :event => 'TestEvent'
  end
  
end

end