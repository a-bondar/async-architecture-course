class Task < ApplicationRecord
  belongs_to :account

  scope :pending, -> { where(completed: false) }
  scope :completed, -> { where(completed: true) }
end
