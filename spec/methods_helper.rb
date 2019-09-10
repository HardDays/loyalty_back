
def create_user
    user = User.new(email: SecureRandom.hex + "@" + SecureRandom.hex + ".xx", password: "1234567", first_name: "test", last_name: "test")
    user.save
    user.create_user_confirmation(confirm_status: :confirmed, confirm_hash: SecureRandom.hex)
    return user
end

def create_creator(user)
    user.create_creator
    return user
end

def create_operator(user, store, company)
    user.create_operator(store_id: store.id, company_id: company.id)
    return user
end

def create_company(user)
    company = Company.new(name: "test")
    company.creator = user.creator
    company.save
    return company
end

def create_store(user)
    store = Store.new(name: "test", country: "test", street: "test", city: "test", house: "1" )
    store.company = user.creator.company
    store.save
    return store
end
