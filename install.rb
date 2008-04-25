require 'fileutils'

__DIR__ = File.dirname(__FILE__)
RAILS_ROOT = __DIR__ + '/../../..'

# generate migration 
# done by user

# add events directory to load path
# done by user

# create events directory
FileUtils.mkdir RAILS_ROOT + '/app/models/events'

# copy mailer template
FileUtils.cp __DIR__ + '/lib/feed_event_mailer.rb.template', RAILS_ROOT + '/app/models/feed_event_mailer.rb' 

# create mailer views directory
FileUtils.mkdir RAILS_ROOT + '/app/views/feed_event_mailer'

# copy controller views, partials
FileUtils.mkdir RAILS_ROOT + '/app/views/feed_events'
FileUtils.cp __DIR__ + '/lib/feed_events_controller.rb.template', RAILS_ROOT + '/app/controllers/feed_events_controller.rb' 
FileUtils.cp __DIR__ + '/views/index.html.erb', RAILS_ROOT + '/app/views/feed_events'
FileUtils.cp __DIR__ + '/views/settings.html.erb', RAILS_ROOT + '/app/views/feed_events'
FileUtils.cp __DIR__ + '/views/destroy.rjs', RAILS_ROOT + '/app/views/feed_events'
FileUtils.cp __DIR__ + '/views/_user_feed.html.erb', RAILS_ROOT + '/app/views/feed_events'

# copy config file
FileUtils.cp __DIR__ + '/social_feed.yml', RAILS_ROOT + '/config'
 
# add routes
# done by user

puts File.read(__DIR__ + '/INSTALL')