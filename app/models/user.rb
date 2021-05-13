# frozen_string_literal: true

# :nodoc:
class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[shibboleth] + [(:developer unless Rails.env.production?)].compact

  has_many :projects, through: :roles, source: :resource, source_type: 'Project'
  has_many :workspaces, through: :projects

  before_validation do
    if provider.blank?
      self.provider = 'local'
      self.uid = email
    end
  end

  after_create do
    Project.create(title: 'Default project').tap do |p|
      add_role :owner, p
    end
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email || auth.uid
      user.password = Devise.friendly_token[0, 20]

      # if/when we add confirmable:
      # user.skip_confirmation!
    end
  end

  def update_from_omniauth(auth)
    update(provider: auth.provider, uid: auth.uid, email: auth.info.email || auth.uid)
  end

  def remove_all_roles(resource)
    roles.where(resource: resource).find_each do |role|
      remove_role role.name, resource
    end
  end

  def resource_roles(resource)
    roles.where(resource: resource)
  end

  protected

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end
end
