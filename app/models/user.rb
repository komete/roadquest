class User < ActiveRecord::Base
  actable as: :utilisateur
  attr_accessor :verification_token, :remember_token, :reset_token
  before_create :create_verified_encrypted_token
  before_save :format_email

  validates :username, presence: true, length: { maximum: 10 }, uniqueness: {case_sensitive: true}
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
  validates :nom,  presence: true, length: { maximum: 50 }
  validates :prenom,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: {case_sensitive: false}
  VALID_TELEPHONE_REGEX = /\A[0-9]{3}\-[0-9]{3}\-[0-9]{4}\z/i
  validates :telephone,  presence: true, format: {with: VALID_TELEPHONE_REGEX}
  validates :poste,  presence: true
  validates :codeEmploye,  presence: {scope: true, message: "Doit être saisit"}, uniqueness: true

  def is_now_verified
    update_attribute(:verified, true)
    update_attribute(:verified_at, Time.zone.now)
  end

  def is_now_desactivated
    update_attribute(:verified, false)
  end

  def create_verified_encrypted_token
    self.verification_token  = User.new_token
    self.verified_digest = User.encrypt_content(verification_token)
  end

  def send_verification_email
    AccountMailer.account_verification(self).deliver_now
  end

  def User.encrypt_content(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.encrypt_content(remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def is_verified?
    self.verified
  end

  def is_admin?
    self.administrateur
  end

  def authenticated?(token_type, token)
    content = send("#{token_type}_digest")
    return false if content.nil?
    BCrypt::Password.new(content).is_password?(token)
  end

  def create_reset_encrypted_token
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.encrypt_content(reset_token))
    update_attribute(:reset_at, Time.zone.now)
  end

  def send_password_reset_email
    AccountMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_at < 2.hours.ago
  end

  :private

    def format_email
      self.email = email.downcase
    end

end
