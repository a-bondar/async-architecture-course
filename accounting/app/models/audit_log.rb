# frozen_string_literal: true

class AuditLog < ApplicationRecord
  belongs_to :account
  belongs_to :task
end

