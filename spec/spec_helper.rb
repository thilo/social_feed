PLUGIN_ROOT = File.dirname(__FILE__) + '/..'

require 'rubygems'
gem 'activerecord'
require 'activerecord'

__DIR__ = File.dirname __FILE__

FileUtils.rm_rf __DIR__ + '/../test.sqlite3'
ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => File.join(File.dirname(__FILE__), '..', 'test.sqlite3')

# migrate

class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
        
    end
  end
end
CreateUsers.up

require PLUGIN_ROOT + '/lib/social_feed/user_extension'
class User < ActiveRecord::Base
  include SocialFeed::UserExtension
end
class FeedEventMailer; end

require File.dirname(__FILE__) + '/../generators/social_feed_migration/templates/migration'
AddSocialFeed.up

require PLUGIN_ROOT + '/lib/object_extensions'


# rspec rails stuff

module Spec
  module Example
    class ExampleGroup 
      
      @@model_id = 1000
      
      def mock_model(model_class, options_and_stubs = {})
        # null = options_and_stubs.delete(:null_object)
        # stubs = options_and_stubs
        id = @@model_id
        @@model_id += 1
        options_and_stubs = {
          :id => id,
          :to_param => id.to_s,
          :new_record? => false,
          :errors => stub("errors", :count => 0)
        }.merge(options_and_stubs)
        m = mock("#{model_class.name}_#{id}", options_and_stubs)
        m.send(:__mock_proxy).instance_eval <<-CODE
          def @target.is_a?(other)
            #{model_class}.ancestors.include?(other)
          end
          def @target.kind_of?(other)
            #{model_class}.ancestors.include?(other)
          end
          def @target.instance_of?(other)
            other == #{model_class}
          end
          def @target.class
            #{model_class}
          end
        CODE
        yield m if block_given?
        m
      end
    end
  end
end

module ActiveRecord #:nodoc:
  class Base

    def errors_on(attribute)
      self.valid?
      [self.errors.on(attribute)].flatten.compact
    end
    alias :error_on :errors_on

  end
end