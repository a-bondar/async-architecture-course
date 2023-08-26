# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :account

  scope :pending, -> { where(status: 'pending') }
  scope :completed, -> { where(status: 'completed') }
end

