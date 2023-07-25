class PostDecorator < Draper::Decorator
  delegate_all

  def likes_count
    object.likes_count
  end
end
