
def create_user
    user = User.new(email: "creator@test.com", password: "1234567", first_name: "test", last_name: "test")
    user.save
    user.create_user_confirmation(confirm_status: :confirmed, confirm_hash: SecureRandom.hex)
    return user
end

def create_creator(user)
    user.create_creator
    return user
end

def create_company(user)
    company = Company.new(name: "test")
    company.creator = user.creator
    company.save
end
