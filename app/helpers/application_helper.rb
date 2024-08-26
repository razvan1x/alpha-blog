module ApplicationHelper

  def gravatar_for(user, options = { size: 80})
    email_address = user.email.downcase
    hash = Digest::MD5.hexdigest(email_address)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{hash}?s=#{size}&d=retro"
    image_tag(gravatar_url, alt: user.username, class: "rounded shadow mx-auto d-block")
  end

end
