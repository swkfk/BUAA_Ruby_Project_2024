# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

%w[Admin Merchant Customer].each do |role_name|
  UserRole.find_or_create_by!(name: role_name)
end

User.find_or_create_by!(name: 'admin') do |user|
  user.name = "admin"
  user.password = "650866740170da66899f27952fb6b7420080e025"
end

if User.find_by(name: 'admin').user_roles.find_by(name: 'Admin').nil?
  User.find_by(name: 'admin').user_roles << UserRole.find_by(name: 'Admin')
end
