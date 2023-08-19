# frozen_string_literal: true

class AccountsConsumer < ApplicationConsumer
  def consume
    messages.each do |message|
      puts '-' * 80
      p message
      puts '-' * 80

      payload = message.payload

      event_name = payload['event_name']
      data = payload['data']

      case event_name
      when 'AccountCreated'
        Account.create!(
          public_id: data['public_id'],
          email: data['email'],
          full_name: data['full_name'],
          position: data['position'],
          role: data['role']
        )
      when 'AccountUpdated'
        account = Account.find_by(public_id: data['public_id'])

        next if account.blank?

        account.update!(
          email: data['email'],
          full_name: data['full_name'],
          position: data['position'],
          role: data['role']
        )
      when 'AccountRoleChanged'
        account = Account.find_by(public_id: data['public_id'])

        next if account.blank?

        account.update!(role: data['role'])
      else
        # store events in DB
      end
    end
  end
end
