class ApplicationRecord < ActiveRecord::Base
  include ArTransactionChanges

  self.abstract_class = true
end
