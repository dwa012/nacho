module Nacho
end

# load Rails/Railtie
begin
  require 'rails'
rescue LoadError
  #do nothing
end

$stderr.puts <<-EOC if !defined?(Rails)
warning: no rails framework detected.
Your Gemfile might not be configured properly.
---- e.g. ----
Rails:
    gem 'nacho'
EOC

require 'nacho/form_builder'
require 'nacho/helper'
require 'nacho/hooks'

if defined? Rails
  require 'nacho/railtie'
  require 'nacho/engine'
end