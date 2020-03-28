resource "Create card" do
    header 'Content-Type', 'application/json'
    header "Authorization", :authorization
  
    post "api/v1/cards" do
      parameter :number, "Card number", type: :string, in: :body, required: true
      parameter :points, "Points", minmum: 0, maximum: 100000000, type: :integer, required: true
      parameter :company_id, "Company id", type: :integer, required: true

      before do
        @user = create_creator(create_user)
        @company = create_company(@user)
        @store = create_store(@user)
        @program = create_program(@company)
        @operator = create_operator(create_user, @store, @company)
      end
  
      let(:authorization) { @operator.token }
      let(:company_id) { @company.id }

      context "Success" do
        let(:points) { 1337 }
        let(:number) { "228 882" }
  
        let(:raw_post) { params.to_json }
  
        example "Success" do
          do_request
          expect(status).to eq(200)
        end
      end
  
      context "Wrong fields" do
  
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
  
      context "User is not operator" do
        before do
          @wrong_user = create_user
        end
  
        let(:authorization) { @wrong_user.token }
        
        let(:raw_post) { params.to_json }

        example "User is not operator" do
          do_request
          expect(status).to eq(403)
        end
      end
    end
  end
  

resource "Create multiple cards" do
  header 'Content-Type', 'application/json'
  header "Authorization", :authorization

  post "api/v1/cards/range" do
    parameter :begin_range, "Begin range", type: :integer, in: :body, required: true
    parameter :end_range, "End range", type: :integer, in: :body, required: true
    parameter :points, "Points", minmum: 0, maximum: 100000000, type: :integer, in: :body, required: true
    parameter :company_id, "Company id", type: :integer, required: true

    before do
      @user = create_creator(create_user)
      @company = create_company(@user)
      @store = create_store(@user)
      @program = create_program(@company)
      @operator = create_operator(create_user, @store, @company)
    end

    let(:authorization) { @operator.token }
    let(:company_id) { @company.id }

    context "Success" do
      let(:points) { 1337 }
      let(:begin_range) { '0000000001' }
      let(:end_range) { '0000000018' }

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

    context "User is not operator" do
      before do
        @wrong_user = create_user
      end

      let(:authorization) { @wrong_user.token }
      let(:raw_post) { params.to_json }

      example "User is not operator" do
        do_request
        expect(status).to eq(403)
      end
    end
  end
end
