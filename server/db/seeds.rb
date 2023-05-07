# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.destroy_all
User.create!([{
               name: 'Myat Theingi Aung',
               email: 'mta@gmail.com',
               password: '12345',
               password_confirmation: '12345',
               bio: 'lorem ipsum',
               role: 0 # admin
             },
              {
                name: 'Ma Ma',
                email: 'mama@gmail.com',
                password: '12345',
                password_confirmation: '12345',
                bio: 'lorem ipsum'
              },
              {
                name: 'Ko Ko',
                email: 'koko@gmail.com',
                password: '12345',
                password_confirmation: '12345',
                bio: 'lorem ipsum'
              }])
p "Created #{User.count} users"

Category.destroy_all
Category.create!([{
                   name: 'laptop'
                 },
                  {
                    name: 'phone'
                  },
                  {
                    name: 'tablet'
                  },
                  {
                    name: 'watch'
                  },
                  {
                    name: 'power bank'
                  },
                  {
                    name: 'earphone'
                  }])
p "Created #{Category.count} categories"

uploader = ImageUploader.new(:store)
file = File.new(Rails.root.join('app/assets/images/watch.jpg'))
uploaded_file = uploader.upload(file)

post = Post.new(
  title: 'Beach Globe Paradise',
  description: "Amber's glow spans skies — write us some place nice, she said I plop chairs on a beach somewhere — one hand grips a frosty margarita and the other well, the other flips off life violently forbidden contestants on...",
  image_data: uploaded_file.to_json,
  user_id: rand(1..3),
  category_id: rand(1..6)
)

post.save!

post = Post.new(
  title: 'The Power of Indulging Your Weird',
  description: "Back in 1964, the microbiologist Thomas Brock visited Yellowstone National Park to do some sightseeing. He was on a long car ride, and wanted to break up the monotony. Amber's glow spans skies — write us some place nice, she said I plop chairs on a beach somewhere — one hand grips a frosty margarita and the other well, the other flips off life violently forbidden contestants on...",
  image_data: uploaded_file.to_json,
  user_id: rand(1..3),
  category_id: rand(1..6)
)
post.save!

p "Created #{Post.count} posts"

Comment.create!([{
                  comment: 'hello',
                  user_id: rand(1..3),
                  post_id: rand(1..2)
                },
                 {
                   comment: 'hello',
                   user_id: rand(1..3),
                   post_id: rand(1..2)
                 }])

p "Created #{Comment.count} comments"
