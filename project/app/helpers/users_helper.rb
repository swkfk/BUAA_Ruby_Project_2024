module UsersHelper
  def hash_password(username, raw_password)
    Digest::SHA1.hexdigest "&&#{username}&&#{raw_password}&&"
  end

  def rand_password
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    Array.new(8, "").collect { chars[rand(chars.size)] }.join
  end
end
