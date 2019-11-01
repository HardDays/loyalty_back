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

resource "Confirmation" do
  header 'Content-Type', 'application/json'

  post "api/v1/auth/confirm" do
    parameter :email, "Email (required if not phone)", type: :string, in: :body
    parameter :phone, "Phone (required if not email)", type: :string, in: :body
    parameter :code, "Code", type: :string, in: :body, required: true
    
    context "Phone" do 
      let(:phone) { "79992281489" }
      let(:code) { "0000" }

      let(:raw_post) { params.to_json }

      example "Phone success" do
        user = User.new(phone: "79992281489", password: '1234567', first_name: "test", last_name: "test")
        user.save
        user.create_user_confirmation(confirm_status: :unconfirmed, code: "0000")

        do_request
        expect(status).to eq(200)
      end
    end

    context "Phone" do 
      let(:email) { "test@text.xxt" }
      let(:code) { "0000" }

      let(:raw_post) { params.to_json }

      example "Phone success" do
        user = User.new(email: "test@text.xxt", password: '1234567', first_name: "test", last_name: "test")
        user.save
        user.create_user_confirmation(confirm_status: :unconfirmed, code: "0000")

        do_request
        expect(status).to eq(200)
      end
    end

    example "Not found" do
      user = User.new(phone: '79992281487', password: '1234567', first_name: "test", last_name: "test")
      user.save
      user.create_user_confirmation(confirm_status: :unconfirmed, code: "0000")

      do_request
      expect(status).to eq(404)
    end
  end
end

resource "Request code password" do
  header 'Content-Type', 'application/json'

  post "api/v1/auth/password/request" do
    parameter :email, "Email (need if not phone)", type: :string, in: :body, required: true
    parameter :phone, "Phone (need if not email)", type: :string, in: :body, required: true
    
    before do
      @user = create_user
    end

    context "Success" do
      let(:email) { @user.email }

      let(:raw_post) { params.to_json }

      example "Success" do
        do_request
        expect(status).to eq(204)
      end
    end

    context "User not found" do
      let(:email) { "test@test.com" }

      let(:raw_post) { params.to_json }

      example "User not found" do
        do_request
        expect(status).to eq(404)
      end
    end
  end
end


resource "Update password" do
  header 'Content-Type', 'application/json'

  post "api/v1/auth/password/update" do
    parameter :code, "Code", type: :string, in: :body, required: true
    parameter :password, "Password", minmum: 7, maximum: 64, type: :string, in: :body, required: true
    parameter :password_confirmation, "Password confirm", minmum: 7, maximum: 64, type: :string, in: :body

    before do
      @user = create_user
      @confirmation = PasswordReset.new(user_id: @user.id, code: SecureRandom.hex, confirm_status: :unconfirmed)
      @confirmation.save
    end

    context "Success" do
      let(:code) { @confirmation.code }
      let(:password) { "11111111" }
      let(:password_confirmation) { "11111111" }

      let(:raw_post) { params.to_json }

      example "Success" do
        do_request
        expect(status).to eq(200)
        expect(@user.authenticate("11111111") != nil).to eq(true)
      end
    end

    context "Wrong fields" do
      let(:code) { @confirmation.code }
      let(:password) { "1" }
      let(:password_confirmation) { "1" }

      let(:raw_post) { params.to_json }

      example "Wrong fields" do
        do_request
        expect(status).to eq(422)
      end
    end

    context "Code not found" do
      let(:code) { "0" }

      let(:raw_post) { params.to_json }

      example "Code not found" do
        do_request
        expect(status).to eq(404)
      end
    end
  end
end

