resource "Create operator" do
  header 'Content-Type', 'application/json'
  header "Authorization", :authorization

  post "api/v1/operators" do
    parameter :email, "Email", type: :string, in: :body, required: true
    parameter :first_name, "First name", minmum: 1, maximum: 128, type: :string, in: :body, required: true
    parameter :last_name, "Last name", minmum: 1, maximum: 128, type: :string, in: :body, required: true
    parameter :second_name, "Second name", minmum: 1, maximum: 128, type: :string, in: :body
    parameter :gender, "Gender", type: :string, in: :body, enum: ["male", "female"]
    parameter :birth_day, "Date of birth (format: dd.mm.yyyy)", type: :string, in: :body
    parameter :store_id, "Store", type: :integer, in: :body

    before do
      @user = create_creator(create_user)
      create_company(@user)
      @store = create_store(@user)
    end

    let(:authorization) { @user.token }

    context "Success" do
      let(:email) { "test@test.com" }
      let(:first_name) { "test" }
      let(:last_name) { "test" }
      let(:second_name) { "test" }
      let(:store_id) { @store.id }

      let(:raw_post) { params.to_json }

      example "Success" do
        do_request
        expect(status).to eq(200)
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

resource "Update operator" do
  header 'Content-Type', 'application/json'
  header "Authorization", :authorization

  put "api/v1/operators/:id" do
    parameter :email, "Email", type: :string, in: :body, required: true
    parameter :first_name, "First name", minmum: 1, maximum: 128, type: :string, in: :body, required: true
    parameter :last_name, "Last name", minmum: 1, maximum: 128, type: :string, in: :body, required: true
    parameter :second_name, "Second name", minmum: 1, maximum: 128, type: :string, in: :body
    parameter :gender, "Gender", type: :string, in: :body, enum: ["male", "female"]
    parameter :birth_day, "Date of birth (format: dd.mm.yyyy)", type: :string, in: :body
    parameter :store_id, "Store", type: :integer, in: :body

    before do
      @creator = create_creator(create_user)
      @company = create_company(@creator)
      @store = create_store(@creator)
      @operator = create_operator(create_user, @store, @company)
    end

    let(:id) { @operator.id }
    let(:authorization) { @creator.token }

    context "Success" do
      let(:email) { "new@test.com" }
      let(:first_name) { "new test" }
      let(:last_name) { "new test" }
      let(:second_name) { "new test" }
      let(:store_id) { @store.id }

      let(:raw_post) { params.to_json }

      example "Success" do
        do_request
        expect(status).to eq(200)

        body = JSON.parse(response_body)
        expect(status).to eq(200)
        expect(body["email"]).to eq("new@test.com")
        expect(body["first_name"]).to eq("new test")
        expect(body["last_name"]).to eq("new test")
        expect(body["second_name"]).to eq("new test")
        expect(body["store_id"]).to eq(@store.id)
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

    context "User is not creator" do
      before do
        @wrong_creator = create_user
      end

      let(:authorization) { @wrong_creator.token }

      example "User is not creator" do
        do_request
        expect(status).to eq(403)
      end
    end
  end
end

resource "Delete operator" do
  header 'Content-Type', 'application/json'
  header "Authorization", :authorization

  delete "api/v1/operators/:id" do
    before do
      @creator = create_creator(create_user)
      @company = create_company(@creator)
      @store = create_store(@creator)
      @operator = create_operator(create_user, @store, @company)
    end

    let(:id) { @operator.id }
    let(:authorization) { @creator.token }

    context "Success" do
      example "Success" do
        do_request
        expect(status).to eq(200)
        expect(User.find(@operator.id).operator.operator_status).to eq('deleted')
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
        @wrong_creator = create_user
      end

      let(:authorization) { @wrong_creator.token }

      example "User is not creator" do
        do_request
        expect(status).to eq(403)
      end
    end
  end
end

resource "Get operators" do
  header 'Content-Type', 'application/json'
  header "Authorization", :authorization

  parameter :store_id, "Store id", type: :integer
  parameter :limit, "Limit", type: :integer
  parameter :offset, "Offset", type: :integer

  before do
    @creator = create_creator(create_user)
    @company = create_company(@creator)
    @store = create_store(@creator)
    create_operator(create_user, @store, @company)
    create_operator(create_user, @store, @company)
    create_operator(create_user, @store, @company)
    create_operator(create_user, @store, @company)
    create_operator(create_user, @store, @company)
  end

  let(:store_id) { @store.id }
  let(:limit) { 3 }

  let(:authorization) { @creator.token }

  get "api/v1/operators" do
    
    context "Success" do
      example "Success" do
        do_request
        body = JSON.parse(response_body)
        expect(body.length).to eq(3)
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

resource "Get operator" do
  header 'Content-Type', 'application/json'
  header "Authorization", :authorization

  get "api/v1/operators/:id" do
    before do
      @creator = create_creator(create_user)
      @company = create_company(@creator)
      @store = create_store(@creator)
      @operator = create_operator(create_user, @store, @company)
    end

    let(:authorization) { @creator.token }
    let(:id) { @operator.id }
      
    # context "Success" do
      
    #   example "Success" do
    #     do_request
    #     expect(status).to eq(200)

    #     body = JSON.parse(response_body)
    #     expect(body["store_id"]).to eq(@store.id)
    #   end
    # end

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
  end
end