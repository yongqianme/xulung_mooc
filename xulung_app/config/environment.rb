# Load the Rails application.
require File.expand_path('../application', __FILE__)
APP_VERSION = `git describe --always` unless defined? APP_VERSION
# Initialize the Rails application.
Rails.application.initialize!
