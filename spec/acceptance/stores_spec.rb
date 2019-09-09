resource "Create store" do
  header 'Content-Type', 'application/json'
  header "Authorization", 'token'

  post "api/v1/stores" do
    parameter :name, "Name", type: :string, minmum: 1, maximum: 128, in: :body, required: true
    parameter :city, "City", type: :string, minmum: 1, maximum: 64, in: :body, required: true
    parameter :country, "Country", type: :string, minmum: 1, maximum: 64, in: :body, required: true
    parameter :street, "Street", type: :string, minmum: 1, maximum: 128, in: :body, required: true
    parameter :house, "House", type: :string, minmum: 1, maximum: 64, in: :body, required: true

    context "Success" do
      before do
        user = create_creator(create_user)
        create_company(user)
        header "Authorization", user.token
      end

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
      before do
        user = create_creator(create_user)
        create_company(user)
        header "Authorization", user.token
      end

      let(:name) { "" }
      let(:city) { "" }

      let(:raw_post) { params.to_json }

      example "Wrong fields" do
        do_request
        expect(status).to eq(422)
      end
    end

    context "Wrong token" do
      example "Wrong token" do
        do_request
        expect(status).to eq(401)
      end
    end

    context "User is not creator" do
      before do
        user = create_user
        header "Authorization", user.token
      end

      example "User is not creator" do
        do_request
        expect(status).to eq(403)
      end
    end
  end
end