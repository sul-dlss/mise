# frozen_string_literal: true

require 'puppeteer'

##
# Captures a screenshot of something
class ScreenshotWorkspaceJob < ApplicationJob
  def perform(workspace)
    Puppeteer.launch(headless: true) do |browser|
      page = browser.pages.first || browser.new_page
      page.goto(embed_path_with_token(workspace))
      page.wait_for_timeout(5000)

      Tempfile.create do |t|
        page.screenshot(path: t.path, type: :png)
        workspace.thumbnail.attach(io: t, content_type: 'image/png', filename: 'thumbnail.png')
      end
    end
  end

  def embed_path_with_token(workspace)
    secret = JWT.encode(
      { workspace: workspace.to_param, exp: 5.minutes.from_now.to_i },
      Rails.application.secret_key_base,
      'HS256'
    )

    Rails.application.routes.url_helpers.url_for(
      { action: 'embed', controller: 'workspaces', id: workspace.to_param, token: secret }
        .merge(Settings.screenshot_url_parameters.to_h)
    )
  end
end
