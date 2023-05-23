class User < ApplicationRecord
  validates :username, presence: true, uniqueness: true, format: { without: /\s/ }
  validates :email, presence: true, uniqueness: true, format: { without: /\s/ }
  validates :password, presence: true, length: { minimum: 6 }
  validates :first_name, presence: true, format: { without: /\s/ }
  validates :last_name, presence: true, format: { without: /\s/ }
  validates :dob, presence: true, format: { without: /\s/ }
  validates :role, presence: true, format: { without: /\s/ }

  has_secure_password
  has_many :blogs, dependent: :destroy
  has_many :comments, dependent: :destroy

  # Used for digesting password within the tests
  def self.digest(password)
    BCrypt::Password.create(password)
  end
end
