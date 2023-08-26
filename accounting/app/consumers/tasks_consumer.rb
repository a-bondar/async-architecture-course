# frozen_string_literal: true
class TasksConsumer < ApplicationConsumer
  def consume
    messages.each do |message|
      puts '-' * 80
      p message
      puts '-' * 80

      payload = message.payload

      event_name = payload['event_name']
      event_version = payload['event_version']
      data = payload['data']

      case [event_name, event_version]
      when ['TaskCreated', 1]
        account = Account.find_by(public_id: data['employee_id'])

        task = Task.create!(
          title: data['title'],
          status: data['status'],
          account:,
          cost: data['cost']
        )

        AuditLog.create!(
          account:,
          task:,
          description: "Task with title: #{task.title} assigned",
          transaction: data['cost']
        )

        account.update!(balance: account.balance + data['cost'])
      when ['TaskAssigned', 1]
        account = Account.find_by(public_id: data['employee_id'])
        task = Task.update!(account:, cost: data['cost'])

        AuditLog.create!(
          title: data['title'],
          task:,
          account:,
          description: "Task with title: #{task.title} assigned",
          transaction: data['cost']
        )

        account.update!(balance: account.balance + data['cost'])
      when ['TaskCompleted', 1]
        account = Account.find_by(public_id: data['employee_id'])
        task = Task.update!(account:, status: data['status'], cost: data['cost'])

        AuditLog.create!(
          title: data['title'],
          task:,
          account:,
          description: "Task with title: #{task.title} completed",
          transaction: data['cost']
        )

        account.update!(balance: account.balance + data['cost'])
      else
        # store events in DB
      end
    end
  end
end

