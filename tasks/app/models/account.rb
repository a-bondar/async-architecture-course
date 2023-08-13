class Account < ApplicationRecord
  has_many :tasks, dependent: :destroy

  scope :employee, -> { where(role: :employee) }
  scope :manager, -> { where(role: :manager) }
  scope :admin, -> { where(role: :admin) }

  enum role: %i[employee manager admin]
end
