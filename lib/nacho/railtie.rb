module Nacho
  class Railtie < ::Rails::Railtie #:nodoc:
    initializer 'nacho' do |_app|
      Nacho::Hooks.init
    end
  end
end