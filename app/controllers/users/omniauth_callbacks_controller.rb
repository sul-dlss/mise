# frozen_string_literal: true

module Users
  # Wiring to integrate Devise + Omniauth
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def shibboleth
      @user = User.from_omniauth(request.env['omniauth.auth'])

      @user.save! unless @user.persisted?

      sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
      set_flash_message(:notice, :success, kind: 'Shibboleth') if is_navigational_format?
    end
  end
end
