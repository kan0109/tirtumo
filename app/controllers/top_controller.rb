class TopController < ApplicationController
  skip_before_action :require_login, only: %i[top]

  def index; end
end
