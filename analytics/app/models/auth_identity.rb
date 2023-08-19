class AuthIdentity < ApplicationRecord
  belongs_to :account, optional: true
end
