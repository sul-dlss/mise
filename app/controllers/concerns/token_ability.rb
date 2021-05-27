# frozen_string_literal: true

# Controller concern injecting token-based abilities
module TokenAbility
  def current_ability
    @current_ability ||= Ability.new(current_user, token: current_token)
  end

  def current_token
    return unless token_from_authorization_header

    payload, _header = JWT.decode(token_from_authorization_header,
                                  Rails.application.secret_key_base,
                                  'HS256')

    HashWithIndifferentAccess.new(payload)
  end

  private

  def token_from_authorization_header
    type, token = request.headers.fetch('Authorization', '').split
    return unless type == 'Bearer'

    token
  end
end
