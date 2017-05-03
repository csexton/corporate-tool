class User < ActiveRecord::Base
  def self.from_omniauth(auth)
    user = find_or_initialize_by provider: auth.provider, uid: auth.uid
    user.name = auth.info.name
    user.email = auth.info.email
    user.save!
    user
  end

  def update_avatar
    fetcher = AvatarFetcher.new(self)
    update_attribute :avatar_url, fetcher.url if fetcher.run
  end
end
