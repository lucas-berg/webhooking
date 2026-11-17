# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # include Clearance::Controller
  include Pagy::Method


  def cookie_webhook_token
    cookies.encrypted['webhook_uuid'].presence
  end

  def setup_cookie_webhook_token(webhook)
    cookies.encrypted['webhook_uuid'] = webhook.uuid
  end
end
