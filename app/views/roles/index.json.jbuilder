# frozen_string_literal: true

json.array! @users, partial: 'roles/user', as: :user
