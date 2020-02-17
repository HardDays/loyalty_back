resource "Create store" do
  header 'Content-Type', 'application/json'
  header "Authorization", :authorization

  parameter :company_id, "Company id", type: :integer, required: true

  post "api/v1/stores" do
    parameter :name, "Name", type: :string, minmum: 1, maximum: 128, in: :body, required: true
    parameter :city, "City", type: :string, minmum: 1, maximum: 64, in: :body, required: true
    parameter :country, "Country", type: :string, minmum: 1, maximum: 64, in: :body, required: true
    parameter :street, "Street", type: :string, minmum: 1, maximum: 128, in: :body, required: true
    parameter :house, "House", type: :string, minmum: 1, maximum: 64, in: :body, required: true

    before do
      @user = create_creator(create_user)
      @company = create_company(@user)
    end

    let(:authorization) { @user.token }
    let(:company_id) { @company.id }

    context "Success" do
      let(:name) { "test" }
      let(:city) { "test" }
      let(:country) { "test" }
      let(:street) { "test" }
      let(:house) { "1" }

      let(:raw_post) { params.to_json }

      example "Success" do
        do_request
        expect(status).to eq(200)
      end
    end

    context "Wrong fields" do
      let(:name) { "" }
      let(:city) { "" }

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

    context "User is not creator" do
      before do
        @wrong_user = create_user
      end

      let(:authorization) { @wrong_user.token }
      let(:raw_post) { params.to_json }

      example "User is not creator" do
        do_request
        expect(status).to eq(403)
      end
    end
  end
end

resource "Update store" do
  header 'Content-Type', 'application/json'
  header "Authorization", :authorization

  parameter :company_id, "Company id", type: :integer, required: true

  before do
    @user = create_creator(create_user)
    @company = create_company(@user)
    @store = create_store(@user)
  end

  let(:id) { @store.id }
  let(:authorization) { @user.token }
  let(:company_id) { @company.id }

  put "api/v1/stores/:id" do
    parameter :name, "Name", type: :string, minmum: 1, maximum: 128, in: :body, required: true
    parameter :city, "City", type: :string, minmum: 1, maximum: 64, in: :body, required: true
    parameter :country, "Country", type: :string, minmum: 1, maximum: 64, in: :body, required: true
    parameter :street, "Street", type: :string, minmum: 1, maximum: 128, in: :body, required: true
    parameter :house, "House", type: :string, minmum: 1, maximum: 64, in: :body, required: true

    context "Success" do
      let(:name) { "new test" }
      let(:city) { "new test" }
      let(:country) { "new test" }
      let(:street) { "new test" }
      let(:house) { "2" }

      let(:raw_post) { params.to_json }

      example "Success" do
        do_request

        body = JSON.parse(response_body)
        expect(status).to eq(200)
        expect(body["name"]).to eq("new test")
        expect(body["city"]).to eq("new test")
        expect(body["country"]).to eq("new test")
        expect(body["street"]).to eq("new test")
        expect(body["house"]).to eq("2")
      end
    end

    context "Wrong fields" do
      let(:name) { "" }
      let(:city) { "" }

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

    context "User is not owner" do
      before do
        @wrong_user = create_creator(create_user)
        create_company(@wrong_user)
      end

      let(:authorization) { @wrong_user.token }
      let(:raw_post) { params.to_json }

      example "User is not owner" do
        do_request
        expect(status).to eq(403)
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
  end
end

# resource "Get store" do
#   header 'Content-Type', 'application/json'
#   header "Authorization", :authorization

#   before do
#     @user = create_creator(create_user)
#     create_company(@user)
#     @store = create_store(@user)
#   end

#   let(:id) { @store.id }
#   let(:authorization) { @user.token }

#   get "api/v1/stores/:id" do

#     context "Success" do
#       example "Success" do
#         do_request
#         expect(status).to eq(200)
#       end
#     end

#     context "Wrong token" do
#       let(:authorization) { "test" }

#       example "Wrong token" do
#         do_request
#         expect(status).to eq(401)
#       end
#     end

#     context "User is not owner" do
#       before do
#         @wrong_user = create_creator(create_user)
#         create_company(@wrong_user)
#       end

#       let(:authorization) { @wrong_user.token }

#       example "User is not owner" do
#         do_request
#         expect(status).to eq(403)
#       end
#     end

#     context "Not found" do
#       let(:id) { 0 }

#       example "Not found" do
#         do_request
#         expect(status).to eq(404)
#       end
#     end
#   end
# end

resource "Delete store" do
  header 'Content-Type', 'application/json'
  header "Authorization", :authorization

  parameter :company_id, "Company id", type: :integer, required: true

  before do
    @user = create_creator(create_user)
    @company = create_company(@user)
    @store = create_store(@user)
  end

  let(:id) { @store.id }
  let(:authorization) { @user.token }
  let(:company_id) { @company.id }

  delete "api/v1/stores/:id" do

    context "Success" do
      let(:raw_post) { params.to_json }

      example "Success" do
        do_request
        expect(status).to eq(204)
        expect(Store.where(id: @store.id).first).to eq(nil)
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

    context "User is not owner" do
      before do
        @wrong_user = create_creator(create_user)
        create_company(@wrong_user)
      end

      let(:authorization) { @wrong_user.token }
      let(:raw_post) { params.to_json }

      example "User is not owner" do
        do_request
        expect(status).to eq(403)
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
  end
end


resource "List stores" do
  header 'Content-Type', 'application/json'
  header "Authorization", :authorization

  parameter :limit, "Limit", type: :integer
  parameter :offset, "Offset", type: :integer
  parameter :company_id, "Company id", type: :integer, required: true

  before do
    @user = create_creator(create_user)
    @company =  create_company(@user)
    create_store(@user)
    create_store(@user)
    create_store(@user)
  end

  let(:authorization) { @user.token }
  let(:company_id) { @company.id }

  get "api/v1/stores" do
    
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
  