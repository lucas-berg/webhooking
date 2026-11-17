# frozen_string_literal: true
# Accounts are optional. An administrator is created only when explicitly configured.
if ENV['ADMIN_EMAIL'].present? && ENV['ADMIN_PASSWORD'].present?
  User.find_or_create_by!(email: ENV['ADMIN_EMAIL']) do |user|
    user.password = ENV['ADMIN_PASSWORD']
    user.admin = true
  end
end
