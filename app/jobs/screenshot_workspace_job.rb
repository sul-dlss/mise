# frozen_string_literal: true

require 'puppeteer'

##
# Captures a screenshot of something
class ScreenshotWorkspaceJob < ApplicationJob
  def perform(workspace, timestamp = nil)
    Puppeteer.launch(headless: true, args: ['--window-size=1280,800']) do |browser|
      page = browser.pages.first || browser.new_page
      page.viewport = Puppeteer::Viewport.new(width: 1280, height: 800)
      page.goto(embed_path_with_token(workspace, timestamp), wait_until: 'domcontentloaded')
      page.wait_for_timeout(3000)

      Tempfile.create do |t|
        page.screenshot(path: t.path, type: :png)
        workspace.thumbnail.attach(io: t, content_type: 'image/png', filename: 'thumbnail.png')
      end
    end
  end

  def embed_path_with_token(workspace, timestamp)
    secret = JWT.encode(
      { workspace: workspace.to_param, exp: 5.minutes.from_now.to_i },
      Rails.application.secret_key_base,
      'HS256'
    )

    Rails.application.routes.url_helpers.url_for(
      { action: 'embed', controller: 'workspaces', id: workspace.to_param, token: secret, timestamp: timestamp }
        .merge(Settings.screenshot_url_parameters.to_h)
    )
  end
end
