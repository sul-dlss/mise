# frozen_string_literal: true
require 'puppeteer'

##
# Captures a screenshot of something
class ScreenshotWorkspaceJob < ApplicationJob
  def perform
    Puppeteer.launch(headless: true) do |browser|
      page = browser.pages.first || browser.new_page
      page.goto("https://github.com/YusukeIwaki")
      page.screenshot(path: "YusukeIwaki.png")
    end
  end
end
