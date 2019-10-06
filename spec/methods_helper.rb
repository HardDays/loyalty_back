def create_user
    user = User.new(email: SecureRandom.hex + "@" + SecureRandom.hex + ".xx", password: "1234567", first_name: "test", last_name: "test")
    user.save
    user.create_user_confirmation(confirm_status: :confirmed, confirm_hash: SecureRandom.hex)
    return user
end

def create_creator(user)
    # t = TariffPlan.new(name: "test", description: "test", days: 7, tariff_type: :demo, price: 0)
    # t.save

    user.create_creator
    return user
end

def create_operator(user, store, company)
    user.create_operator(store_id: store.id, company_id: company.id)
    return user
end

def create_client(company)
    user = User.new(phone: "+" + rand(10000..100000000).to_s, password: "1234567", first_name: "test", last_name: "test")
    user.save
    user.create_user_confirmation(confirm_status: :confirmed, confirm_hash: SecureRandom.hex)
    user.create_client(company_id: company.id)
    return user
end

def create_company(user)
    company = Company.new(name: "test")
    company.creator = user.creator
    
    # tariff_plan = TariffPlan.new(name: "test", description: "test", days: 7, tariff_type: :demo, price: 0)
    # tariff_plan.save
    #company.create_tariff_plan_purchase(tariff_plan_id: tariff_plan.id, expired_at: DateTime.now + tariff_plan.days.days)

    company.save

    return company
end

def create_store(user)
    store = Store.new(name: "test", country: "test", street: "test", city: "test", house: "1" )
    store.company = user.creator.company
    store.save
    return store
end

def create_program(company)
    program = LoyaltyProgram.new(name: "test", company_id: company.id)
    program.loyalty_levels.build(
        "level_type": "one_buy",
        "min_price": 100,
        "begin_date": "31.08.2019",
        "end_date": "02.10.2019",
        "burning_rule": "no_burning",
        "activation_rule": "activation_moment",
        "write_off_rule": "write_off_convert",
        "rounding_rule": "no_rounding",
        "accordance_rule": "no_accordance",
        "accrual_rule": "no_accrual",
        "write_off_rule_percent": 30,
        "write_off_rule_points": 100,
        "write_off_money": 1,
        "write_off_points": 1,
        "accrual_on_points": false,
        "accrual_on_register": false,
        "accrual_on_first_buy": false,
        "accrual_on_birthday": false,
        "sms_on_register": false,
        "sms_on_points": false,
        "sms_on_write_off": false,
        "sms_on_burning": false
    )
    program.save
    return program
end

def create_promotion(company)
    program = Promotion.new(name: "test", company_id: company.id, begin_date: "31.08.2019", end_date: "02.10.2019")
    program.loyalty_levels.build(
        "level_type": "one_buy",
        "min_price": 100,
        "burning_rule": "no_burning",
        "activation_rule": "activation_moment",
        "write_off_rule": "write_off_convert",
        "rounding_rule": "no_rounding",
        "accordance_rule": "no_accordance",
        "accrual_rule": "no_accrual",
        "write_off_rule_percent": 30,
        "write_off_rule_points": 100,
        "write_off_money": 1,
        "write_off_points": 1,
        "accrual_on_points": false,
        "accrual_on_register": false,
        "accrual_on_first_buy": false,
        "accrual_on_birthday": false,
        "sms_on_register": false,
        "sms_on_points": false,
        "sms_on_write_off": false,
        "sms_on_burning": false
    )
    program.save
    return program
end

# def create_tariff_plan
#     tariff = TariffPlan.new(name: "test", description: "test", days: 30, tariff_type: :paid, price: 100000)
#     tariff.save
#     return tariff
# end