class User < ActiveRecord::Base
  def self.from_omniauth(auth)
    user = find_or_initialize_by provider: auth.provider, uid: auth.uid
    user.name = auth.info.name
    user.email = auth.info.email
    user.save!
    user
  end
end
