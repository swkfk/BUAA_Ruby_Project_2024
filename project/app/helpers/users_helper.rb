module UsersHelper
  def hash_password(username, raw_password)
    Digest::SHA1.hexdigest "&&#{username}&&#{raw_password}&&"
  end
end
