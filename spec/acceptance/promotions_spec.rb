resource "Create promotion" do
    header 'Content-Type', 'application/json'
    header "Authorization", :authorization
  
    post "api/v1/promotions" do
      before do
        @user = create_creator(create_user)
        create_company(@user)
      end
  
      let(:authorization) { @user.token }
  
      context "Success" do
        parameter :name, "Name", type: :string, minmum: 1, maximum: 128, in: :body, required: true
        parameter :begin_date, "Begin date (in format dd.mm.yyyy)", type: :string, in: :body, required: true
        parameter :end_date, "End date (in format dd.mm.yyyy)", type: :string, in: :body, required: true
        parameter :accrual_rule, "Accrual rule", type: :string, in: :body, required: true, enum: ["no_accrual", "accrual_percent", "accrual_convert"]
        parameter :accrual_percent, "Percent for 'accrual_percent' rule", type: :integer, minmum: 0, maximum: 100, in: :body
        parameter :accrual_points, "Points for 'accrual_convert' rule", type: :integer, minmum: 0, maximum: 10000000000, in: :body
        parameter :accrual_money, "Money for 'accrual_convert' rule (IN CENTS)", type: :integer, minmum: 0, maximum: 10000000000, in: :body
        parameter :burning_rule, "Burning rule", type: :string, in: :body, required: true, enum: ["no_burning", "burning_days"]
        parameter :burning_days, "Days for 'burning_days' rule", type: :integer, minmum: 1, maximum: 365, in: :body
        parameter :activation_rule, "Activation rule", type: :string, in: :body, required: true, enum: ["activation_moment", "activation_days"]
        parameter :activation_days, "Days for 'activation_days' rule", type: :integer, minmum: 1, maximum: 365, in: :body
        parameter :write_off_rule, "Write off rule", type: :string, in: :body, required: true, enum: ["no_write_off", "write_off_convert"]
        parameter :write_off_rule_percent, "Percent for 'write_off_convert' rule", type: :integer, minmum: 0, maximum: 100, in: :body
        parameter :write_off_rule_points, "Points for 'write_off_convert' rule", type: :integer, minmum: 0, maximum: 10000000000, in: :body
        parameter :accordance_rule, "Accordance rule", type: :string, in: :body, required: true, enum: ["no_accordance", "accordance_convert"]
        parameter :accordance_percent, "Percent for 'accordance_convert' rule", type: :integer, minmum: 0, maximum: 100, in: :body
        parameter :accordance_points, "Points for 'accordance_convert' rule", type: :integer, minmum: 0, maximum: 10000000000, in: :body
        parameter :rounding_rule, "Rounding rule", type: :string, in: :body, required: true, enum: ["no_rounding", "rounding_math", "rounding_small", "rounding_big"]
        parameter :accrual_on_points, "Accrual when points added", type: :boolean, in: :body, required: true
        parameter :write_off_limited, "Min price limited", type: :boolean, in: :body, required: true
        parameter :write_off_min_price, "Min price for 'write_off_limited'", type: :integer, in: :body, required: true

        let(:name) { "test" }
        let(:begin_date) { "31.08.2019"}
        let(:end_date) { "31.12.2019"}
        let(:accrual_rule) { "no_accrual"}
        let(:burning_rule) { "no_burning"}
        let(:activation_rule) { "activation_moment"}
        let(:accordance_rule) { "no_accordance"}
        let(:rounding_rule) { "no_rounding"}
        let(:write_off_rule) { "no_write_off"}
        let(:write_off_rule_percent) { 1 }
        let(:write_off_rule_points) { 1 }
        let(:accrual_on_points) { false }
        let(:write_off_limited) { false }

        let(:raw_post) { params.to_json }
  
        example "Success" do
          do_request
          expect(status).to eq(200)
        end
      end
  
      context "Wrong fields" do
        let(:name) { "" }
  
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
  
  resource "Update promotion" do
    header 'Content-Type', 'application/json'
    header "Authorization", :authorization
  
    put "api/v1/promotions/:id" do
      before do
        @user = create_creator(create_user)
        @company = create_company(@user)
        @program = create_promotion(@company)
      end
  
      let (:id) { @program.id }
      let(:authorization) { @user.token }
  
      context "Success" do
        parameter :name, "Name", type: :string, minmum: 1, maximum: 128, in: :body, required: true
    
        let(:name) { "test" }
  
        let(:raw_post) { params.to_json }
  
        example "Success" do
          do_request
          body = JSON.parse(response_body)
          expect(status).to eq(200)
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
  
  resource "Delete promotion" do
    header 'Content-Type', 'application/json'
    header "Authorization", :authorization
  
    delete "api/v1/promotions/:id" do
      before do
        @user = create_creator(create_user)
        @company = create_company(@user)
        @program = create_promotion(@company)
      end
  
      let (:id) { @program.id }
      let(:authorization) { @user.token }
  
      context "Success" do
        example "Success" do
          do_request
          expect(status).to eq(204)
          expect(Promotion.where(id: @program.id).first).to eq(nil)
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
  
  resource "List promotions" do
    header 'Content-Type', 'application/json'
    header "Authorization", :authorization
  
    parameter :limit, "Limit", type: :integer
    parameter :offset, "Offset", type: :integer
  
    get "api/v1/promotions" do
      before do
        @user = create_creator(create_user)
        @company = create_company(@user)
        create_program(@company)
      end
  
      let(:authorization) { @user.token }
  
      context "Success" do
        example "Success" do
          do_request
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