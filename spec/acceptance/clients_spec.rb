require 'acceptance_helper'

resource "List clients" do
  header 'Content-Type', 'application/json'
  header "Authorization", :authorization

  get "api/v1/clients" do
    parameter :phone, "Phone", type: :string,  required: false
    parameter :name, "Name", minmum: 1, maximum: 128, type: :string, required: false
    parameter :card_number, "Name", minmum: 1, maximum: 128, type: :string, required: false
    parameter :limit, "Limit", type: :integer, required: false
    parameter :offset, "Offset", type: :integer, required: false
    parameter :company_id, "Company id", type: :integer, required: true

    before do
      @creator = create_creator(create_user)
      @company = create_company(@creator)
      @store = create_store(@creator)
      create_program(@company)
      @operator = create_operator(create_user, @store, @company)
      @client_user = create_client(@company)
    end

    let(:authorization) { @operator.token }
    let(:company_id) { @company.id }

    context "Success" do
      let(:phone) { @client_user.phone }
      let(:name) { @client_user.first_name }
      let(:card_number) { @client_user.client(@company).card_number }

      let(:raw_post) { params.to_json }

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

    context "User is not operator" do
      before do
        @wrong_user = create_user
      end

      let(:authorization) { @wrong_user.token }

      example "User is not operator" do
        do_request
        expect(status).to eq(403)
      end
    end
  end
end

resource "Check client phone" do
  header 'Content-Type', 'application/json'
  header "Authorization", :authorization

  get "api/v1/clients/phone" do
    parameter :phone, "Phone", type: :string,  required: false
    parameter :company_id, "Company id", type: :integer, required: true

    before do
      @creator = create_creator(create_user)
      @company = create_company(@creator)
      @store = create_store(@creator)
      @operator = create_operator(create_user, @store, @company)
      @program = create_program(@company)
      @client_user = create_client(@company)
    end

    let(:authorization) { @operator.token }
    let(:company_id) { @company.id }

    context "Success" do
      let(:phone) { @client_user.phone }

      let(:raw_post) { params.to_json }

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

    context "User is not operator" do
      before do
        @wrong_user = create_user
      end

      let(:authorization) { @wrong_user.token }

      example "User is not operator" do
        do_request
        expect(status).to eq(403)
      end
    end
  end
end

resource "Create client" do
  header 'Content-Type', 'application/json'
  header "Authorization", :authorization

  post "api/v1/clients" do
    parameter :phone, "Phone", type: :string, in: :body, required: true
    parameter :email, "Email", type: :string, in: :body, required: true
    parameter :first_name, "First name", minmum: 1, maximum: 128, type: :string, in: :body, required: true
    parameter :last_name, "Last name", minmum: 1, maximum: 128, type: :string, in: :body, required: true
    parameter :second_name, "Second name", minmum: 1, maximum: 128, type: :string, in: :body
    parameter :gender, "Gender", type: :string, in: :body, enum: ["male", "female"]
    parameter :birth_day, "Date of birth (format: dd.mm.yyyy)", type: :string, in: :body
    #parameter :loyalty_program_id, "Loyalty program", type: :integer, in: :body
    parameter :card_number, "Card number", type: :string, in: :body
    parameter :recommendator_phone, "Recommendator phone", type: :string, in: :body, required: false
    parameter :company_id, "Company id", type: :integer, required: true

    before do
      @user = create_creator(create_user)
      @company = create_company(@user)
      @store = create_store(@user)
      @program = create_program(@company)
      @operator = create_operator(create_user, @store, @company)
    end

    let(:authorization) { @operator.token }
    let(:company_id) { @company.id }

    context "Success" do
      let(:phone) { "79992238223" }
      let(:email) { "abcd@abcd.abc" }
      let(:first_name) { "test" }
      let(:last_name) { "test" }
      let(:second_name) { "test" }
      let(:gender) { "male" }
      let(:birth_day) { "12.07.2018" }

      let(:raw_post) { params.to_json }

      example "Success" do
        do_request
        expect(status).to eq(200)
      end
    end

    context "Wrong fields" do
      let(:email) { "f" }
      let(:first_name) { "" }

      let(:raw_post) { params.to_json }

      example "Wrong fields" do
        do_request
        expect(status).to eq(422)
      end
    end

    context "Wrong token" do
      let(:authorization) { "test" }
      let(:raw_post) { params.to_json }

      example "Wrong token" do
        do_request
        expect(status).to eq(401)
      end
    end

    context "User is not operator" do
      before do
        @wrong_user = create_user
      end

      let(:authorization) { @wrong_user.token }
      let(:raw_post) { params.to_json }

      example "User is not operator" do
        do_request
        expect(status).to eq(403)
      end
    end
  end
end

resource "Update client" do
  header 'Content-Type', 'application/json'
  header "Authorization", :authorization

  put "api/v1/clients/:id" do
    # parameter :phone, "Phone (format: 7xxxxxxxxxx)", type: :string, in: :body, required: true
    # parameter :email, "Email", type: :string, in: :body, required: true
    # parameter :first_name, "First name", minmum: 1, maximum: 128, type: :string, in: :body, required: true
    # parameter :last_name, "Last name", minmum: 1, maximum: 128, type: :string, in: :body, required: true
    # parameter :second_name, "Second name", minmum: 1, maximum: 128, type: :string, in: :body
    # parameter :gender, "Gender", type: :string, in: :body, enum: ["male", "female"]
    # parameter :birth_day, "Date of birth (format: dd.mm.yyyy)", type: :string, in: :body
    #parameter :loyalty_program_id, "Loyalty program", type: :integer, in: :body
    parameter :card_number, "Card number", type: :string, in: :body
    parameter :company_id, "Company id", type: :integer, required: true

    before do
      @creator = create_creator(create_user)
      @company = create_company(@creator)
      @store = create_store(@creator)
      @operator = create_operator(create_user, @store, @company)
      @program = create_program(@company)
      @client_user = create_client(@company)
    end

    let(:id) { @client_user.id }
    let(:authorization) { @operator.token }
    let(:company_id) { @company.id }

    context "Success" do

      let(:raw_post) { params.to_json }

      example "Success" do
        do_request
        expect(status).to eq(200)

        body = JSON.parse(response_body)
        expect(status).to eq(200)
      end
    end

    context "Not found" do
      let(:id) { 0 }
      let(:raw_post) { params.to_json }

      example "Not found" do
        do_request
        expect(status).to eq(404)
      end
    end

    context "Wrong token" do
      let(:authorization) { "test" }
      let(:raw_post) { params.to_json }

      example "Wrong token" do
        do_request
        expect(status).to eq(401)
      end
    end

    context "User is not operator" do
      before do
        @wrong_operator = create_user
      end

      let(:authorization) { @wrong_operator.token }
      let(:raw_post) { params.to_json }

      example "User is not operator" do
        do_request
        expect(status).to eq(403)
      end
    end
  end
end

resource "Add points" do
  header 'Content-Type', 'application/json'
  header "Authorization", :authorization

  post "api/v1/clients/:id/points" do
    parameter :points, "Points", minmum: 0, maximum: 100000000, type: :integer, in: :body, required: true
    parameter :company_id, "Company id", type: :integer, required: true

    before do
      @creator = create_creator(create_user)
      @company = create_company(@creator)
      @store = create_store(@creator)
      @operator = create_operator(create_user, @store, @company)
      @program = create_program(@company)
      @client_user = create_client(@company)
    end

    let(:id) { @client_user.id }
    let(:authorization) { @creator.token }
    let(:company_id) { @company.id }

    context "Success" do
      let(:points) { 100000 }

      let(:raw_post) { params.to_json }

      example "Success" do
        do_request
        expect(status).to eq(200)
      end
    end

    context "Wrong token" do
      let(:authorization) { "test" }
      let(:raw_post) { params.to_json }

      example "Wrong token" do
        do_request
        expect(status).to eq(401)
      end
    end

    context "User is not operator" do
      before do
        @wrong_user = create_user
      end

      let(:authorization) { @wrong_user.token }
      let(:raw_post) { params.to_json }

      example "User is not operator" do
        do_request
        expect(status).to eq(403)
      end
    end
  end
end

resource "Remove points" do
  header 'Content-Type', 'application/json'
  header "Authorization", :authorization

  delete "api/v1/clients/:id/points" do
    parameter :points, "Points", minmum: 0, maximum: 100000000, type: :integer, in: :body, required: true
    parameter :company_id, "Company id", type: :integer, required: true

    before do
      @creator = create_creator(create_user)
      @company = create_company(@creator)
      @store = create_store(@creator)
      @operator = create_operator(create_user, @store, @company)
      @program = create_program(@company)
      @client_user = create_client(@company)
    end

    let(:id) { @client_user.id }
    let(:authorization) { @creator.token }
    let(:company_id) { @company.id }

    context "Success" do
      let(:points) { 100000 }

      let(:raw_post) { params.to_json }

      example "Success" do
        do_request
        expect(status).to eq(200)
      end
    end

    context "Wrong token" do
      let(:authorization) { "test" }
      let(:raw_post) { params.to_json }

      example "Wrong token" do
        do_request
        expect(status).to eq(401)
      end
    end

    context "User is not operator" do
      before do
        @wrong_user = create_user
      end

      let(:authorization) { @wrong_user.token }
      let(:raw_post) { params.to_json }

      example "User is not operator" do
        do_request
        expect(status).to eq(403)
      end
    end
  end
end

resource "Client profile" do
  header 'Content-Type', 'application/json'
  header "Authorization", :authorization

  get "api/v1/clients/profile" do
    parameter :company_id, "Company id", type: :integer, required: true

    before do
      @creator = create_creator(create_user)
      @company = create_company(@creator)
      @program = create_program(@company)
      @client_user = create_client(@company)
    end

    let(:authorization) { @client_user.token }
    let(:company_id) { @company.id }

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
  end
end

resource "Client orders" do
  header 'Content-Type', 'application/json'
  header "Authorization", :authorization

  parameter :company_id, "Company id", type: :integer, required: true

  get "api/v1/clients/profile/orders" do
    before do
      @creator = create_creator(create_user)
      @company = create_company(@creator)
      @store = create_store(@creator)
      @operator = create_operator(create_user, @store, @company)
      @program = create_program(@company)
      @client_user = create_client(@company)
      @promotion = create_promotion(@company)
      @order = create_order(@client_user, @operator, @store, @promotion)
    end

    let(:authorization) { @client_user.token }
    let(:company_id) { @company.id }

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
  end
end

resource "Update profile" do
  header 'Content-Type', 'application/json'
  header "Authorization", :authorization

  put "api/v1/clients/profile" do
    #parameter :phone, "Phone (format: 7xxxxxxxxxx)", type: :string, in: :body, required: true
    #parameter :email, "Email", type: :string, in: :body, required: true
    parameter :first_name, "First name", minmum: 1, maximum: 128, type: :string, in: :body, required: true
    parameter :last_name, "Last name", minmum: 1, maximum: 128, type: :string, in: :body, required: true
    parameter :second_name, "Second name", minmum: 1, maximum: 128, type: :string, in: :body
    parameter :gender, "Gender", type: :string, in: :body, enum: ["male", "female"]
    #parameter :birth_day, "Date of birth (format: dd.mm.yyyy)", type: :string, in: :body
    #parameter :loyalty_program_id, "Loyalty program", type: :integer, in: :body
    #parameter :card_number, "Card number", type: :string, in: :body
    parameter :company_id, "Company id", type: :integer, required: true

    before do
      @creator = create_creator(create_user)
      @company = create_company(@creator)
      @store = create_store(@creator)
      @operator = create_operator(create_user, @store, @company)
      @program = create_program(@company)
      @client_user = create_client(@company)
    end

    let(:authorization) { @client_user.token }
    let(:company_id) { @company.id }

    context "Success" do
      let(:first_name) { "new test" }
      let(:last_name) { "new test" }
      let(:second_name) { "new test" }

      let(:raw_post) { params.to_json }

      example "Success" do
        do_request
        expect(status).to eq(200)
      end
    end

    context "Wrong fields" do
      let(:first_name) { "" }
      let(:store_id) { 0 }

      let(:raw_post) { params.to_json }

      example "Wrong fields" do
        do_request
        expect(status).to eq(422)
      end
    end

    context "Wrong token" do
      let(:authorization) { "test" }
      let(:raw_post) { params.to_json }

      example "Wrong token" do
        do_request
        expect(status).to eq(401)
      end
    end
  end
end

resource "Update vk" do
  header 'Content-Type', 'application/json'
  header "Authorization", :authorization

  post "api/v1/clients/profile/vk" do

    parameter :access_token, "Vk access token", minmum: 1, maximum: 128, type: :string, in: :body, required: true
    parameter :company_id, "Company id", type: :integer, required: true

    before do
      @creator = create_creator(create_user)
      @company = create_company(@creator)
      @store = create_store(@creator)
      @operator = create_operator(create_user, @store, @company)
      @program = create_program(@company)
      @client_user = create_client(@company)
    end

    let(:authorization) { @client_user.token }
    let(:company_id) { @company.id }

    context "Success" do
      let(:access_token) { "gfgdgwh48gehrghdfig" }

      let(:raw_post) { params.to_json }

      example "Success" do
        do_request
      end
    end

    context "Wrong token" do
      let(:authorization) { "test" }
      let(:raw_post) { params.to_json }

      example "Wrong token" do
        do_request
        expect(status).to eq(401)
      end
    end
  end
end


resource "Update telegram" do
  header 'Content-Type', 'application/json'
  header "Authorization", :authorization

  post "api/v1/clients/profile/telegram" do

    parameter :telegram_username, "Telegram username", minmum: 1, maximum: 128, type: :string, in: :body, required: true
    parameter :company_id, "Company id", type: :integer, required: true

    before do
      @creator = create_creator(create_user)
      @company = create_company(@creator)
      @store = create_store(@creator)
      @operator = create_operator(create_user, @store, @company)
      @program = create_program(@company)
      @client_user = create_client(@company)
    end

    let(:authorization) { @client_user.token }
    let(:company_id) { @company.id }

    context "Success" do
      let(:telegram_username) { "Userdfskfdjsk" }

      let(:raw_post) { params.to_json }

      example "Success" do
        do_request
        expect(status).to eq(200)
      end
    end

    context "Wrong token" do
      let(:authorization) { "test" }
      let(:raw_post) { params.to_json }

      example "Wrong token" do
        do_request
        expect(status).to eq(401)
      end
    end
  end
end