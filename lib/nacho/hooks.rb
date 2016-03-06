module Nacho
  class Hooks
    def self.init
      ActiveSupport.on_load(:action_view) do
        ::ActionView::Base.send :include, Nacho::Helper
      end
    end
  end
end