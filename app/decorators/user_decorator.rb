class UserDecorator < ApplicationDecorator
  delegate_all

  def name
    object.name
  end
end
