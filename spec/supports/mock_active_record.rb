class ActiveRecord::Base
  def self.transaction(*args)
    yield(*args)
  end
end
