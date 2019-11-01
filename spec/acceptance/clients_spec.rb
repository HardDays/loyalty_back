require 'acceptance_helper'

resource "List clients" do
  header 'Content-Type', 'application/json'
  header "Authorization", :authorization

  get "api/v1/clients" do
    parameter :phone, "Phone", type: :string,  required: false
    parameter :name, "Name", minmum: 1, maximum: 128, type: :string, required: false
    parameter :limit, "Limit", type: :integer, required: false
    parameter :offset, "Offset", type: :integer, required: false

    before do
      @creator = create_creator(create_user)
      @company = create_company(@creator)
      @store = create_store(@creator)
      @operator = create_operator(create_user, @store, @company)
      @client_user = create_client(@company)
    end

    let(:authorization) { @operator.token }

    context "Success" do
      let(:phone) { @client_user.phone }
      let(:name) { @client_user.first_name }

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

    before do
      @creator = create_creator(create_user)
      @company = create_company(@creator)
      @store = create_store(@creator)
      @operator = create_operator(create_user, @store, @company)
      @client_user = create_client(@company)
    end

    let(:authorization) { @operator.token }

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
    parameter :first_name, "First name", minmum: 1, maximum: 128, type: :string, in: :body, required: true
    parameter :last_name, "Last name", minmum: 1, maximum: 128, type: :string, in: :body, required: true
    parameter :second_name, "Second name", minmum: 1, maximum: 128, type: :string, in: :body
    parameter :gender, "Gender", type: :string, in: :body, enum: ["male", "female"]
    parameter :birth_day, "Date of birth (format: dd.mm.yyyy)", type: :string, in: :body
    #parameter :loyalty_program_id, "Loyalty program", type: :integer, in: :body
    parameter :card_number, "Card number", type: :string, in: :body

    before do
      @user = create_creator(create_user)
      @company = create_company(@user)
      @store = create_store(@user)
      @operator = create_operator(create_user, @store, @company)
    end

    let(:authorization) { @operator.token }

    context "Success" do
      let(:phone) { "79992238223" }
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

resource "Update client" do
  header 'Content-Type', 'application/json'
  header "Authorization", :authorization

  put "api/v1/clients/:id" do
    parameter :phone, "Phone (format: 7xxxxxxxxxx)", type: :string, in: :body, required: true
    parameter :first_name, "First name", minmum: 1, maximum: 128, type: :string, in: :body, required: true
    parameter :last_name, "Last name", minmum: 1, maximum: 128, type: :string, in: :body, required: true
    parameter :second_name, "Second name", minmum: 1, maximum: 128, type: :string, in: :body
    parameter :gender, "Gender", type: :string, in: :body, enum: ["male", "female"]
    parameter :birth_day, "Date of birth (format: dd.mm.yyyy)", type: :string, in: :body
    #parameter :loyalty_program_id, "Loyalty program", type: :integer, in: :body
    parameter :card_number, "Card number", type: :string, in: :body

    before do
      @creator = create_creator(create_user)
      @company = create_company(@creator)
      @store = create_store(@creator)
      @operator = create_operator(create_user, @store, @company)
      @client_user = create_client(@company)
    end

    let(:id) { @client_user.id }
    let(:authorization) { @operator.token }

    context "Success" do
      let(:phone) { "380501009533" }
      let(:first_name) { "new test" }
      let(:last_name) { "new test" }
      let(:second_name) { "new test" }

      let(:raw_post) { params.to_json }

      example "Success" do
        do_request
        expect(status).to eq(200)

        body = JSON.parse(response_body)
        expect(status).to eq(200)
        expect(body["phone"]).to eq("380501009533")
        expect(body["first_name"]).to eq("new test")
        expect(body["last_name"]).to eq("new test")
        expect(body["second_name"]).to eq("new test")
      end
    end

    context "Wrong fields" do
      let(:email) { "f" }
      let(:first_name) { "" }
      let(:store_id) { 0 }

      let(:raw_post) { params.to_json }

      example "Wrong fields" do
        do_request
        expect(status).to eq(422)
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

    context "User is not operator" do
      before do
        @wrong_operator = create_user
      end

      let(:authorization) { @wrong_operator.token }

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
    parameter :phone, "Phone", type: :string, in: :body, required: true
    parameter :first_name, "First name", minmum: 1, maximum: 128, type: :string, in: :body, required: true
    parameter :last_name, "Last name", minmum: 1, maximum: 128, type: :string, in: :body, required: true
    parameter :second_name, "Second name", minmum: 1, maximum: 128, type: :string, in: :body
    parameter :gender, "Gender", type: :string, in: :body, enum: ["male", "female"]
    parameter :birth_day, "Date of birth (format: dd.mm.yyyy)", type: :string, in: :body
    parameter :loyalty_program_id, "Loyalty program", type: :integer, in: :body
    parameter :card_number, "Card number", type: :string, in: :body

    before do
      @creator = create_creator(create_user)
      @company = create_company(@creator)
      @store = create_store(@creator)
      @operator = create_operator(create_user, @store, @company)
      @client_user = create_client(@company)
    end

    let(:authorization) { @client_user.token }

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

    context "User is not operator" do
      before do
        @wrong_operator = create_user
      end

      let(:authorization) { @wrong_operator.token }

      example "User is not client" do
        do_request
        expect(status).to eq(403)
      end
    end
  end
end