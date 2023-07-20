class TopController < ApplicationController
  skip_before_action :require_login, only: %i[index]

  def index; end

  def terms; end

  def privacy; end

  def contact; end
end
