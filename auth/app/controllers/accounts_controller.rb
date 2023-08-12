class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :edit, :update, :destroy]

  before_action :authenticate_account!, only: [:index]
  def index
    @accounts = Account.all
  end

  def current
    respond_to do |format|
      format.json  { render :json => current_account }
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      new_role = @account.role != account_params[:role] ? account_params[:role] : nil

      if @account.update(account_params)
        # ----------------------------- produce event -----------------------
        event = {
          event_name: 'AccountUpdated',
          data: {
            public_id: @account.public_id,
            email: @account.email,
            full_name: @account.full_name,
            position: @account.position
          }
        }
        Producer.call(event.to_json, topic: 'accounts-stream')

        if new_role
          event = {
            event_name: 'AccountRoleChanged',
            data: { public_id: @account.public_id, role: @account.role }
          }
          # Producer.call(event.to_json, topic: 'accounts')
        end

        # --------------------------------------------------------------------
        format.html { redirect_to root_path, notice: 'Account was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @account.update(active: false, disabled_at: Time.now)

    # ----------------------------- produce event -----------------------
    event = {
      event_name: 'AccountDeleted',
      data: { public_id: @account.public_id }
    }
    Producer.call(event.to_json, topic: 'accounts-stream')
    # --------------------------------------------------------------------

    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Account was successfully destroyed.' }
    end
  end

  private

  def current_account
    if doorkeeper_token
      Account.find(doorkeeper_token.resource_owner_id)
    else
      super
    end
  end

  def set_account
    @account = Account.find(params[:id])
  end

  def account_params
    params[:account][:role] = params[:account][:role].to_i

    params.require(:account).permit(:full_name, :role)
  end
end

