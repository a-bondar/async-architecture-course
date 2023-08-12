class Account < ApplicationRecord
  before_create :assign_id
  after_create :produce_account_created_event

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :access_grants,
           class_name: 'Doorkeeper::AccessGrant',
           foreign_key: :resource_owner_id,
           dependent: :delete_all # or :destroy if you need callbacks

  has_many :access_tokens,
           class_name: 'Doorkeeper::AccessToken',
           foreign_key: :resource_owner_id,
           dependent: :delete_all # or :destroy if you need callbacks

  enum role: [:employee, :manager, :admin]

  def assign_id
    self.public_id = SecureRandom.uuid if self.public_id.blank?
  end

  def produce_account_created_event
    event = {
      event_name: 'AccountCreated',
      data: {
        public_id: self.public_id,
        email: self.email,
        full_name: self.full_name,
        position: self.position
      }
    }

    Producer.call(event.to_json, topic: 'accounts-stream')
  end
end
