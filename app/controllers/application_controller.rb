# frozen_string_literal: true

# Abstract parent of all controllers
class ApplicationController < ActionController::Base
  include TokenAbility

  check_authorization unless: :devise_controller?

  before_action :set_paper_trail_whodunnit
end
