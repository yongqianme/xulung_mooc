# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
['free', 'student', 'engineer', 'enterprise'].each do |type|
  Membership.find_or_create_by({type: type})
end
# 1000.times do
#   User.create(username:Faker::Internet.user_name,
#               email:Faker::Internet.free_email,
#               password: "testtesttest",
#               password_confirmation: Faker::Internet.password)
# end
Membership.create([{ type: 'free_member'},{ type: 'student_member'},{ type: 'engineer_member'},{ type: 'enterprise_member'}])
