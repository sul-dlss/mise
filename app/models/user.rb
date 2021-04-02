# frozen_string_literal: true

# :nodoc:
class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[shibboleth]

  before_validation do
    if provider.blank?
      self.provider = 'local'
      self.uid = email
    end
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]

      # if/when we add confirmable:
      # user.skip_confirmation!
    end
  end
end
