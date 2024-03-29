# Preview all emails at http://localhost:3000/rails/mailers/account_mailer
class AccountMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/account_mailer/account_verification
  def account_verification
    account = Account.first
    account.verification_token = Account.new_token
    AccountMailer.account_verification(account)

    #AccountMailer.account_verification
  end

  # Preview this email at http://localhost:3000/rails/mailers/account_mailer/password_reset
  def password_reset
    AccountMailer.password_reset
  end

end
