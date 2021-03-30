# frozen_string_literal: true

# Home page controller
class HomeController < ApplicationController
  skip_authorization_check

  def show; end
end
