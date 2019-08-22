5.times do
  Company.create({
      email: Faker::Internet.email,
      password:Faker::Internet.password,
      password_confirm:Faker::Internet.password,
      hash:Faker::Internet.hash,
      is_validate: 1
                 })
end