require 'acceptance_helper'

resource "Register creator" do
  header 'Content-Type', 'application/json'

  post "api/v1/creators" do
    parameter :email, "Email", type: :string, in: :body, required: true
    parameter :password, "Password", minmum: 7, maximum: 64, type: :string, in: :body, required: true
    parameter :password_confirmation, "Password confirm", minmum: 7, maximum: 64, type: :string, in: :body
    parameter :first_name, "First name", minmum: 1, maximum: 128, type: :string, in: :body, required: true
    parameter :last_name, "Last name", minmum: 1, maximum: 128, type: :string, in: :body, required: true
    parameter :second_name, "Second name", minmum: 1, maximum: 128, type: :string, in: :body
    parameter :gender, "Gender", type: :string, in: :body, enum: ["male", "female"]
    parameter :birth_day, "Date of birth (format: dd.mm.yyyy)", type: :string, in: :body

    context "Success" do
      let(:email) { "test@test.com" }
      let(:password) { "1234567" }
      let(:password_confirmation) { "1234567" }
      let(:first_name) { "test" }
      let(:last_name) { "test" }
      let(:second_name) { "test" }

      let(:raw_post) { params.to_json }

      example "Success" do
        do_request
        expect(status).to eq(200)
      end
    end

    context "Wrong fields" do
      let(:email) { "test" }
      let(:password) { "123456" }
      let(:password_confirmation) { "1234567" }
      let(:last_name) { "" }

      let(:raw_post) { params.to_json }

      example "Wrong fields" do
        do_request
        expect(status).to eq(422)
      end
    end
  end

  get "api/v1/creators" do
    parameter :email, "Email", type: :string

    context "Success" do
      let(:email) { "test@test.com" }

      example "Success" do
        do_request
        expect(status).to eq(200)
      end
    end
  end
end

