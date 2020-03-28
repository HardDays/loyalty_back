require 'acceptance_helper'
require 'methods_helper'

resource "Get 1c token" do
  header 'Content-Type', 'application/json'
  header "Authorization", :authorization
  parameter :company_id, "Company id", type: :integer, required: true

  get "api/v1/service_tokens/one_s" do
    before do
        @user = create_creator(create_user)
        @company = create_company(@user)
    end
  
    let(:authorization) { @user.token }
    let(:company_id) { @company.id }

    context "Success" do

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
