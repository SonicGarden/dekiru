class ActiveRecord::Base
  def self.transaction
    yield
  end
end
