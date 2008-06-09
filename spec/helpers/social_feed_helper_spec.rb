require File.dirname(__FILE__) + '/../spec_helper'
require PLUGIN_ROOT + '/lib/social_feed/social_feed_helper'
include SocialFeed::SocialFeedHelper
class TestEvent; end
class TestEventCreatedEvent; end

describe SocialFeed::SocialFeedHelper do
  
  it "should derive the hint partial from the feed class" do
    feed_event_partial_name(TestEvent.new).should == 'test_hint'
  end
  
  it "should only replace event with hint at the end" do
    feed_event_partial_name(TestEventCreatedEvent.new).should == 'test_event_created_hint'
  end
  
end