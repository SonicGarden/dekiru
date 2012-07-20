module Dekiru
  class Railtie < ::Rails::Railtie
    initializer 'dekiru' do |app|
      ActiveSupport.on_load(:action_view) do
        ::ActionView::Base.send :include, Dekiru::Helper
      end
    end
  end
end
