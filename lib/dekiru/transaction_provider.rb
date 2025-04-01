module Dekiru
  class TransactionProvider
    def within_transaction(&)
      ActiveRecord::Base.transaction(&)
    end

    def current_transaction_open?
      ActiveRecord::Base.connection.current_transaction.open?
    end
  end
end
