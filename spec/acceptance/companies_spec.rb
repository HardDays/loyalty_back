require 'acceptance_helper'
require 'methods_helper'

resource "Create company" do
  header 'Content-Type', 'application/json'
  header "Authorization", 'token'

  post "api/v1/companies" do
    parameter :name, "Name", type: :string, minmum: 1, maximum: 128, in: :body, required: true

    context "Success" do
        before do
            user = create_creator(create_user)
            header "Authorization", user.token
        end

        let(:name) { "test" }

        let(:raw_post) { params.to_json }

        example "Success" do
            do_request
            expect(status).to eq(200)
        end
    end

    context "Wrong fields" do
        before do
            user = create_creator(create_user)
            header "Authorization", user.token
        end

        let(:name) { "" }

        let(:raw_post) { params.to_json }

        example "Wrong fields" do
            do_request
            expect(status).to eq(422)
        end
    end

    context "Wrong token" do
        let(:name) { "test" }

        let(:raw_post) { params.to_json }

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

        let(:name) { "test" }

        let(:raw_post) { params.to_json }

        example "User is not creator" do
            do_request
            expect(status).to eq(403)
        end
    end
  end
end

resource "Update company" do
  header 'Content-Type', 'application/json'
  header "Authorization", 'token'

  put "api/v1/companies" do
    parameter :name, "Name", type: :string, minmum: 1, maximum: 128, in: :body, required: true

    context "Success" do
      before do
          user = create_creator(create_user)
          create_company(user)
          header "Authorization", user.token
      end

      let(:name) { "new name" }

      let(:raw_post) { params.to_json }

      example "Success" do
          do_request
          expect(status).to eq(200)
          expect(JSON.parse(response_body)["name"]).to eq("new name")
      end
    end

    context "Wrong fields" do
      before do
          user = create_creator(create_user)
          create_company(user)
          header "Authorization", user.token
      end

      let(:name) { "" }

      let(:raw_post) { params.to_json }

      example "Wrong fields" do
          do_request
          expect(status).to eq(422)
      end
    end

    context "Wrong token" do
      let(:name) { "test" }

      let(:raw_post) { params.to_json }

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

      let(:name) { "test" }

      let(:raw_post) { params.to_json }

      example "User is not creator" do
          do_request
          expect(status).to eq(403)
      end
    end
  end
end
  
resource "Get company" do
  header 'Content-Type', 'application/json'
  header "Authorization", 'token'

  get "api/v1/companies" do  
    context "Success" do
      before do
          user = create_creator(create_user)
          create_company(user)
          header "Authorization", user.token
      end

      example "Success" do
          do_request
          expect(status).to eq(200)
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
  