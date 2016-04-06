require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(nom: 'SOUDANI', prenom: 'Haikel', poste: '1', email: 'soudanio@gmail.com',
                 codeEmploye: 'SOUH25128500', telephone: '514-666-6699', username: 'ooligan', administrateur: false,
                 password: 'admin3', password_confirmation: 'admin3', verified: true, verified_at: Time.zone.now)
  end

  test "Doit être valide" do
    assert @user.valid?
  end

  test "Nom présent" do
    @user = users(:remi)
    assert_not_equal @user.nom, "Remi"
  end
end
