resource "Create loyalty program" do
  header 'Content-Type', 'application/json'
  header "Authorization", :authorization

  post "api/v1/loyalty_programs" do
    before do
      @user = create_creator(create_user)
      create_company(@user)
    end

    let(:authorization) { @user.token }

    context "Loyalty level description" do
      parameter :level_type, "Level type", type: :string, in: :body, required: true, enum: ["one_buy", "sum_buy"]
      parameter :min_price, "Min price or sum for activate bonus (IN CENTS)", type: :integer, minmum: 1, maximum: 10000000000, in: :body, required: true
      parameter :begin_date, "Begin date (in format dd.mm.yyyy)", type: :string, in: :body, required: true
      parameter :end_date, "End date (in format dd.mm.yyyy)", type: :string, in: :body, required: true
      parameter :write_off_points, "How much points to write off (money * (write_off_points / write_off_money))", type: :integer, minmum: 1, maximum: 10000000000, in: :body, required: true
      parameter :write_off_money, "How much money to write off (IN CENTS)", type: :integer, minmum: 1, maximum: 10000000000, in: :body, required: true
      parameter :accrual_rule, "Accrual rule", type: :string, in: :body, required: true, enum: ["no_accrual", "accrual_percent", "accrual_convert"]
      parameter :accrual_percent, "Percent for 'accrual_percent' rule", type: :integer, minmum: 1, maximum: 100, in: :body
      parameter :accrual_points, "Points for 'accrual_convert' rule", type: :integer, minmum: 1, maximum: 10000000000, in: :body
      parameter :accrual_money, "Money for 'accrual_convert' rule (IN CENTS)", type: :integer, minmum: 1, maximum: 10000000000, in: :body
      parameter :burning_rule, "Burning rule", type: :string, in: :body, required: true, enum: ["no_burning", "burning_days"]
      parameter :burning_days, "Days for 'burning_days' rule", type: :integer, minmum: 1, maximum: 365, in: :body
      parameter :activation_rule, "Activation rule", type: :string, in: :body, required: true, enum: ["activation_moment", "activation_days"]
      parameter :activation_days, "Days for 'activation_days' rule", type: :integer, minmum: 1, maximum: 365, in: :body
      parameter :write_off_rule, "Write off rule", type: :string, in: :body, required: true, enum: ["no_write_off", "write_off_convert"]
      parameter :write_off_rule_percent, "Percent for 'write_off_convert' rule", type: :integer, minmum: 1, maximum: 100, in: :body
      parameter :write_off_rule_points, "Points for 'write_off_convert' rule", type: :integer, minmum: 1, maximum: 10000000000, in: :body
      parameter :accordance_rule, "Accordance rule", type: :string, in: :body, required: true, enum: ["no_accordance", "accordance_convert"]
      parameter :accordance_percent, "Percent for 'accordance_convert' rule", type: :integer, minmum: 1, maximum: 100, in: :body
      parameter :accordance_points, "Points for 'accordance_convert' rule", type: :integer, minmum: 1, maximum: 10000000000, in: :body
      parameter :rounding_rule, "Rounding rule", type: :string, in: :body, required: true, enum: ["no_rounding", "rounding_math", "rounding_small", "rounding_big"]
      parameter :accrual_on_points, "Accrual when points added", type: :boolean, in: :body, required: true
      parameter :accrual_on_register, "Accrual when registered", type: :boolean, in: :body, required: true
      parameter :accrual_on_first_buy, "Accrual on first purchase", type: :boolean, in: :body, required: true
      parameter :accrual_on_birthday, "Accrual on birthday", type: :boolean, in: :body, required: true
      parameter :register_points, "Points for 'accrual_on_register'", type: :integer, minmum: 1, maximum: 10000000000, in: :body
      parameter :first_buy_points, "Points for 'accrual_on_first_buy'", type: :integer, minmum: 1, maximum: 10000000000, in: :body
      parameter :birthday_points, "Points for 'accrual_on_birthday'", type: :integer, minmum: 1, maximum: 10000000000, in: :body
      parameter :sms_on_register, "Sms on register", type: :boolean, in: :body, required: true
      parameter :sms_on_points, "Sms on points", type: :boolean, in: :body, required: true
      parameter :sms_on_write_off, "Sms on write off", type: :boolean, in: :body, required: true
      parameter :sms_on_burning, "Sms on burning", type: :boolean, in: :body, required: true
      parameter :sms_burning_days, "Days for 'sms_on_burning'", type: :integer, minmum: 1, maximum: 365, in: :body

      example "Loyalty level description" do
        
      end
    end

    context "Success" do
      parameter :name, "Name", type: :string, minmum: 1, maximum: 128, in: :body, required: true
      parameter :loyalty_levels, "Loyalty level", type: :array, minmum: 1, in: :body, required: true
  
      let(:name) { "test" }
      let(:loyalty_levels) do
        [
          {
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
          }
        ]
      end

      let(:raw_post) { params.to_json }

      example "Success" do
        do_request
        expect(status).to eq(200)
      end
    end

    context "Wrong fields" do
      let(:name) { "" }

      let(:raw_post) { params.to_json }
      let(:loyalty_levels) do
        [
          {
            "level_type": "one_buy",
            "min_price": 100,
            "burning_rule": "no_burning",
            "write_off_rule_points": 100,
            "write_off_money": 1,
            "write_off_points": 1,
            "accrual_on_points": false,
            "accrual_on_register": false,
            "accrual_on_first_buy": false
          }
        ]
      end

      example "Wrong fields" do
        do_request
        expect(status).to eq(422)
      end
    end

    context "Wrong token" do
      let(:authorization) { "test" }

      example "Wrong token" do
        do_request
        expect(status).to eq(401)
      end
    end

    context "User is not creator" do
      before do
        @wrong_user = create_user
      end

      let(:authorization) { @wrong_user.token }

      example "User is not creator" do
        do_request
        expect(status).to eq(403)
      end
    end
  end
end

resource "Update loyalty program" do
  header 'Content-Type', 'application/json'
  header "Authorization", :authorization

  put "api/v1/loyalty_programs/:id" do
    before do
      @user = create_creator(create_user)
      @company = create_company(@user)
      @program = create_program(@company)
    end

    let (:id) { @program.id }
    let(:authorization) { @user.token }

    context "Success" do
      parameter :name, "Name", type: :string, minmum: 1, maximum: 128, in: :body, required: true
  
      let(:name) { "test" }

      let(:raw_post) { params.to_json }

      example "Success" do
        do_request
        body = JSON.parse(response_body)
        expect(status).to eq(200)
        expect(body["loyalty_levels"].length).to eq(1)
      end
    end

    context "Not found" do
      let(:id) { 0 }

      example "Not found" do
        do_request
        expect(status).to eq(404)
      end
    end

    context "Wrong token" do
      let(:authorization) { "test" }

      example "Wrong token" do
        do_request
        expect(status).to eq(401)
      end
    end

    context "User is not creator" do
      before do
        @wrong_user = create_user
      end

      let(:authorization) { @wrong_user.token }

      example "User is not creator" do
        do_request
        expect(status).to eq(403)
      end
    end
  end
end

resource "Delete loyalty program" do
  header 'Content-Type', 'application/json'
  header "Authorization", :authorization

  delete "api/v1/loyalty_programs/:id" do
    before do
      @user = create_creator(create_user)
      @company = create_company(@user)
      @program = create_program(@company)
    end

    let (:id) { @program.id }
    let(:authorization) { @user.token }

    context "Success" do
      example "Success" do
        do_request
        expect(status).to eq(204)
        expect(LoyaltyProgram.where(id: @program.id).first).to eq(nil)
      end
    end

    context "Not found" do
      let(:id) { 0 }

      example "Not found" do
        do_request
        expect(status).to eq(404)
      end
    end

    context "Wrong token" do
      let(:authorization) { "test" }

      example "Wrong token" do
        do_request
        expect(status).to eq(401)
      end
    end

    context "User is not creator" do
      before do
        @wrong_user = create_user
      end

      let(:authorization) { @wrong_user.token }

      example "User is not creator" do
        do_request
        expect(status).to eq(403)
      end
    end
  end
end

resource "List loyalty programs" do
  header 'Content-Type', 'application/json'
  header "Authorization", :authorization

  parameter :limit, "Limit", type: :integer
  parameter :offset, "Offset", type: :integer

  get "api/v1/loyalty_programs" do
    before do
      @user = create_creator(create_user)
      @company = create_company(@user)
      create_program(@company)
    end

    let(:authorization) { @user.token }

    context "Success" do
      example "Success" do
        do_request
        expect(status).to eq(200)
      end
    end

    context "Wrong token" do
      let(:authorization) { "test" }

      example "Wrong token" do
        do_request
        expect(status).to eq(401)
      end
    end

    context "User is not creator" do
      before do
        @wrong_user = create_user
      end

      let(:authorization) { @wrong_user.token }

      example "User is not creator" do
        do_request
        expect(status).to eq(403)
      end
    end
  end
end