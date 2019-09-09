require 'acceptance_helper'
require 'methods_helper'

resource "Register client" do
  header 'Content-Type', 'application/json'
  header "Authorization", :authorization

  post "api/v1/clients" do
    parameter :phone, "Phone", type: :string, in: :body, required: true
    parameter :password, "Password", minmum: 7, maximum: 64, type: :string, in: :body, required: true
    parameter :password_confirmation, "Password confirm", minmum: 7, maximum: 64, type: :string, in: :body
    parameter :first_name, "First name", minmum: 1, maximum: 128, type: :string, in: :body, required: true
    parameter :last_name, "Last name", minmum: 1, maximum: 128, type: :string, in: :body, required: true
    parameter :second_name, "Second name", minmum: 1, maximum: 128, type: :string, in: :body
    parameter :gender, "Gender", type: :string, in: :body, enum: ["male", "female"]
    parameter :card_number, "Card", minmum: 1, maximum: 64, type: :string, in: :body
    parameter :birth_day, "Date of birth (format: dd.mm.yyyy)", type: :string, in: :body
    parameter :loyalty_program_id, "Id of program", type: :integer, in: :body

    # context "Success" do
    #     let(:phone) { "test@test.com" }
    #     let(:first_name) { "test" }
    #     let(:last_name) { "test" }
    #     let(:second_name) { "test" }
    #     let(:gender) { "male" }
    #     let(:birth_day) { "15.07.2018" }
    #     let(:card_number) { "12345" }
    #     let(:loyalty_program_id) { 1 }

    #     let(:authroization) { token }

    #     let(:raw_post) { params.to_json }

    #     example "Success" do
    #         do_request
    #         expect(status).to eq(200)
    #     end
    # end

    # context "Wrong fields" do
    #     let(:phone) { "" }
    #     let(:password) { "123456" }
    #     let(:password_confirmation) { "1234567" }
    #     let(:last_name) { "" }
    #     let(:gender) { "pacan" }

    #     let(:raw_post) { params.to_json }

    #     example "Wrong fields" do
    #         do_request
    #         expect(status).to eq(422)
    #     end
    # end

  end

end

