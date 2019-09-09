require 'acceptance_helper'

resource "Login" do
  header 'Content-Type', 'application/json'

  post "api/v1/auth/login" do
    parameter :email, "Email (need if not phone)", type: :string, in: :body, required: true
    parameter :phone, "Phone (need if not email)", type: :string, in: :body, required: true
    parameter :password, "Password", type: :string, in: :body, required: true
    
    let(:email) { "test@test.com" }
    let(:password) { "1234567" }

    let(:raw_post) { params.to_json }

    example "Success" do
      user = User.new(email: email, password: password, first_name: "test", last_name: "test")
      user.save
      user.create_user_confirmation(confirm_status: :confirmed, confirm_hash: SecureRandom.hex)

      do_request
      expect(status).to eq(200)
    end

    example "User not found" do
      do_request
      expect(status).to eq(404)
    end

    example "Wrong password" do
      user = User.new(email: email, password: '7654321', first_name: "test", last_name: "test")
      user.save
      user.create_user_confirmation(confirm_status: :confirmed, confirm_hash: SecureRandom.hex)

      do_request
      expect(status).to eq(401)
    end

    example "Email or phone not confirmed" do
      user = User.new(email: email, password: password, first_name: "test", last_name: "test")
      user.save
      user.create_user_confirmation(confirm_status: :unconfirmed, confirm_hash: SecureRandom.hex)

      do_request
      expect(status).to eq(403)
    end
  end
end

resource "Phone confirmation" do
  header 'Content-Type', 'application/json'

  post "api/v1/auth/confirm/phone" do
    parameter :phone, "Phone", type: :string, in: :body, required: true
    parameter :code, "Code", type: :string, in: :body, required: true
    
    let(:phone) { "+9992281489" }
    let(:code) { "0000" }

    let(:raw_post) { params.to_json }

    example "Success" do
      user = User.new(phone: phone, password: '1234567', first_name: "test", last_name: "test")
      user.save
      user.create_user_confirmation(confirm_status: :unconfirmed, code: code)

      do_request
      expect(status).to eq(200)
    end

    example "Not found" do
      user = User.new(phone: '+9992281487', password: '1234567', first_name: "test", last_name: "test")
      user.save
      user.create_user_confirmation(confirm_status: :unconfirmed, code: code)

      do_request
      expect(status).to eq(404)
    end
  end
end

resource "Email confirmation" do
  header 'Content-Type', 'application/json'

  post "api/v1/auth/confirm/email" do
    parameter :email, "Email", type: :string, in: :body, required: true
    parameter :confirm_hash, "Hash", type: :string, in: :body, required: true
    
    let(:email) { "tt@tt.tt" }
    let(:confirm_hash) { "hash" }

    let(:raw_post) { params.to_json }

    example "Success" do
      user = User.new(email: email, password: '1234567', first_name: "test", last_name: "test")
      user.save
      user.create_user_confirmation(confirm_status: :unconfirmed, confirm_hash: confirm_hash)

      do_request
      expect(status).to eq(200)
    end

    example "Not found" do
      user = User.new(email: 'tt@tt.tt1', password: '1234567', first_name: "test", last_name: "test")
      user.save
      user.create_user_confirmation(confirm_status: :unconfirmed, confirm_hash: '1111')

      do_request
      expect(status).to eq(404)
    end
  end
end
