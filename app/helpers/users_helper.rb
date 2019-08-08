module UsersHelper
  def gravatar_for user, size: Settings.microposts.default_size
    gravatar_id = Digest::MD5::hexdigest user.email.downcase
    gravatar_url = "http://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag gravatar_url, alt: user.name, class: "gravatar"
  end

  def load_relationship user_id
    current_user.active_relationships.find_by followed_id: user_id
  end

  def build_reloatioship
    current_user.active_relationships.build
  end
end
