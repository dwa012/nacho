require 'nacho/form_builder'
require 'nacho/helper'


module Nacho
  module Rails
    class Engine < ::Rails::Engine
    end
  end
end


ActionView::Base.send :include, Nacho::Helper