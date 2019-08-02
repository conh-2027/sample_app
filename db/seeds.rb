# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
10.times do |n|
  User.create!(
    name: FFaker::Name.name,
    email: FFaker::Internet.email,
    password: "Abc123123",
    password_confirmation: "Abc123123"
  )
end

users = User.order(:created_at).take(6)
50.times do
  content = FFaker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content) }
end
