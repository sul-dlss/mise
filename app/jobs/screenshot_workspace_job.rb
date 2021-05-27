# frozen_string_literal: true

require 'puppeteer'

##
# Captures a screenshot of something
class ScreenshotWorkspaceJob < ApplicationJob
  include Rails.application.routes.url_helpers

  # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
  def perform(workspace, timestamp = nil)
    Puppeteer.launch(headless: true, args: ['--window-size=1280,800']) do |browser|
      page = browser.pages.first || browser.new_page
      page.viewport = Puppeteer::Viewport.new(width: 1280, height: 800)
      # NOTE: We are using #request_interception and #on here to conditionally
      #       inject authorization headers into requests *only* destined for the
      #       Mise service, which is how we temporarily defeat our authorization
      #       strategy to enable screenshotting. We cannot use the simpler
      #       #extra_http_headers method, else the authorization header *also*
      #       gets sent, e.g., to remote IIIF manifest URLs such as PURL, and
      #       this is a CORS no-no, causing our screenshots to look like error
      #       pages.
      page.request_interception = true
      page.on('request') do |req|
        local_headers = if req.url.starts_with?(root_url(url_parameters))
                          { 'Authorization' => "Bearer #{workspace_token(workspace)}" }
                        else
                          {}
                        end

        req.continue(headers: req.headers.merge(local_headers))
      end
      page.goto(embed_workspace_url(workspace, url_parameters.merge(timestamp: timestamp)),
                wait_until: 'domcontentloaded')
      page.wait_for_timeout(3000)

      Tempfile.create do |t|
        page.screenshot(path: t.path, type: :png)
        workspace.thumbnail.attach(io: t, content_type: 'image/png', filename: 'thumbnail.png')
      end
    end
  end
  # rubocop:enable Metrics/AbcSize,Metrics/MethodLength

  private

  def workspace_token(workspace)
    JWT.encode({ workspace: workspace.to_param, exp: 5.minutes.from_now.to_i },
               Rails.application.secret_key_base,
               'HS256')
  end

  def url_parameters
    Settings.screenshot_url_parameters.to_h
  end
end
