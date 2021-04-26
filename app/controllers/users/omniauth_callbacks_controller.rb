# frozen_string_literal: true

module Users
  # Wiring to integrate Devise + Omniauth
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def shibboleth
      @user = load_user

      sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
      set_flash_message(:notice, :success, kind: 'Shibboleth') if is_navigational_format?
    end

    def load_user
      return load_user_from_invitation if params[:invitation_token].present?

      resource_class.from_omniauth(request.env['omniauth.auth']).tap do |user|
        user.save! unless user.persisted?
      end
    end

    def load_user_from_invitation
      resource_class.accept_invitation!(invitation_token: params[:invitation_token]).tap do |user|
        user.update_from_omniauth(request.env['omniauth.auth'])
        user.save
      end
    end
  end
end
