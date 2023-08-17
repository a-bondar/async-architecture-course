class SessionsController < ApplicationController
  def new
    render :new
  end

  def create
    account_info = request.env['omniauth.auth']

    account = Account.find_by_auth_identity(account_info['provider'], auth_identity_params(account_info))

    if account.nil?
      account = Account.create_with_identity(account_info['provider'], account_params(account_info), auth_identity_params(account_info))
    end

    session[:account] = account

    redirect_to tasks_path
  end

  def destroy
    session[:user_id] = nil

    redirect_to root_path
  end

  private

  def account_params(payload)
    {
      public_id: payload['info']['public_id'],
      full_name: payload['info']['full_name'],
      email: payload['info']['email'],
      role: payload['info']['role']
    }
  end

  def auth_identity_params(payload)
    {
      uid: payload['uid'],
      token: payload['credentials']['token'],
      login: payload['info']['email']
    }
  end
end