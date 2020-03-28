require 'acceptance_helper'

# resource "Register creator" do
#   header 'Content-Type', 'application/json'

#   post "api/v1/creators" do
#     parameter :email, "Email", type: :string, in: :body, required: true
#     parameter :phone, "Phone", type: :string, in: :body, required: true
#     parameter :password, "Password", minmum: 7, maximum: 64, type: :string, in: :body, required: true
#     parameter :password_confirmation, "Password confirm", minmum: 7, maximum: 64, type: :string, in: :body
#     parameter :first_name, "First name", minmum: 1, maximum: 128, type: :string, in: :body, required: true
#     parameter :last_name, "Last name", minmum: 1, maximum: 128, type: :string, in: :body, required: true
#     parameter :second_name, "Second name", minmum: 1, maximum: 128, type: :string, in: :body
#     parameter :gender, "Gender", type: :string, in: :body, enum: ["male", "female"]
#     parameter :birth_day, "Date of birth (format: dd.mm.yyyy)", type: :string, in: :body

#     context "Success" do
#       let(:email) { "test@test.com" }
#       let(:phone) { "+79993331122" }
#       let(:password) { "1234567" }
#       let(:password_confirmation) { "1234567" }
#       let(:first_name) { "test" }
#       let(:last_name) { "test" }
#       let(:second_name) { "test" }

#       let(:raw_post) { params.to_json }

#       example "Success" do
#         do_request
#         expect(status).to eq(200)
#       end
#     end

#     context "Wrong fields" do
#       let(:email) { "test" }
#       let(:password) { "123456" }
#       let(:password_confirmation) { "1234567" }
#       let(:last_name) { "" }

#       let(:raw_post) { params.to_json }

#       example "Wrong fields" do
#         do_request
#         expect(status).to eq(422)
#       end
#     end
#   end

#   get "api/v1/creators" do
#     parameter :email, "Email", type: :string

#     context "Success" do
#       let(:email) { "test@test.com" }

#       example "Success" do
#         do_request
#         expect(status).to eq(200)
#       end
#     end
#   end
# end


resource "Update creator profile" do
  header 'Content-Type', 'application/json'
  header "Authorization", :authorization
  put "api/v1/creators/profile" do
      
    parameter :email, "Email", type: :string, in: :body, required: false
    parameter :current_password, "Current password", minmum: 7, maximum: 64, type: :string, in: :body, required: false
    parameter :password, "Password", minmum: 7, maximum: 64, type: :string, in: :body, required: false
    parameter :password_confirmation, "Password confirm", minmum: 7, maximum: 64, type: :string, in: :body, required: false
    parameter :first_name, "First name", minmum: 1, maximum: 128, type: :string, in: :body, required: false
    parameter :last_name, "Last name", minmum: 1, maximum: 128, type: :string, in: :body, required: false
    parameter :second_name, "Second name", minmum: 1, maximum: 128, type: :string, in: :body, required: false
    parameter :gender, "Gender", type: :string, in: :body, enum: ["male", "female"], required: false
    parameter :birth_day, "Date of birth (format: dd.mm.yyyy)", type: :string, in: :body, required: false

    before do
      @user = create_user
      @creator = create_creator(@user)
    end

    let(:authorization) { @user.token }

    context "Success" do
      let(:email) { "test@test.com" }
      let(:current_password) { "1234567" }
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

    context "Wrong password" do
      let(:email) { "test" }
      let(:current_password) { "1234" }
      let(:password) { "1234567" }
      let(:password_confirmation) { "1234567" }
      let(:last_name) { "dsdssd" }

      let(:raw_post) { params.to_json }

      example "Wrong password" do
        do_request
        expect(status).to eq(403)
      end
    end

    context "Wrong fields" do
      let(:email) { "test" }
      let(:last_name) { "" }

      let(:raw_post) { params.to_json }

      example "Wrong fields" do
        do_request
        expect(status).to eq(422)
      end
    end
  end
end