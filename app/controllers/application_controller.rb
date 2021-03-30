# frozen_string_literal: true

class ApplicationController < ActionController::Base
  check_authorization unless: :devise_controller?
end
