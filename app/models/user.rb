class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true

  devise :database_authenticatable,
         :jwt_authenticatable,
         :registerable,
         jwt_revocation_strategy: JwtDenylist
end