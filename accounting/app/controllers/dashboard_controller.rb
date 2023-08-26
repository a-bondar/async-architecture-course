class DashboardController < ApplicationController
  def index
    @balance = balance
    @items = current_account.audit_logs if current_account.employee?
    @items = AuditLog.all if current_account.manager? || current_account.admin?
  end

  private

  def current_account
    Account.find_by(id: session[:account]["id"])
  end

  def balance
    if current_account.employee?
      current_account.balance
    else
      (Task.completed.pluck(:cost).sum + Task.pending.pluck(:cost).sum) * -1
    end

  end
end
