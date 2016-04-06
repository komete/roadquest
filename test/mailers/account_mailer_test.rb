require 'test_helper'

class AccountMailerTest < ActionMailer::TestCase
  test "account_verification" do
    #mail = AccountMailer.account_verification(Account.new)
    #assert_equal "Activation du compte", mail.subject
    #assert_equal ["guillaume.remi@courrier.uqam.ca;brien-lejeune.stephanie@courrier.uqam.ca;sawadogo.abdoul_faical@courrier.uqam.ca"], mail.to
    #assert_equal ["localhost:3000"], mail.from
  end

  test "password_reset" do
    mail = AccountMailer.password_reset
    #assert_equal "Password reset", mail.subject
    #assert_equal ["to@example.org"], mail.to
    #assert_equal ["from@example.com"], mail.from
    #assert_match "Hi", mail.body.encoded
  end

end
