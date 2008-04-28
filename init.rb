require 'object_extensions'

# configuration
require 'ostruct'
SocialFeed::Conf = OpenStruct.new :sender_email => '<no-reply@mydomain.com>'


ActionController::Base.helper(SocialFeed::SocialFeedHelper) 

ActionController::Routing::RouteSet::Mapper.send(:include, SocialFeed::Routing)