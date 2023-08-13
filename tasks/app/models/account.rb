class Account < ApplicationRecord
  has_many :tasks, dependent: :destroy
  has_many :auth_identities, dependent: :destroy

  enum role: %i[employee manager admin]

  def find_by_auth_identity(provider, identity_params)
    Account
      .joins(:auth_identities)
      .where(auth_identities: { provider: identity_params[:provider], login: identity_params[:login] })
      .first
  end

  def create_with_identity(provider, account, auth_identity)
    Account.transaction do
      account = Account.create!(account)
      account.auth_identities.create!(auth_identity.merge(provider:))

      account
    end
  end
end
