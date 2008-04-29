require 'object_extensions'

# configuration
require 'ostruct'
SocialFeed::Conf = OpenStruct.new YAML::load(File.read(RAILS_ROOT + '/config/social_feed.yml'))


ActionController::Base.helper(SocialFeed::SocialFeedHelper) 

ActionController::Routing::RouteSet::Mapper.send(:include, SocialFeed::Routing)