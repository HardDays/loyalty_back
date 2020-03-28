resource "Sms" do
    header 'Content-Type', 'application/json'
    header "Authorization", :authorization
    
    parameter :message, "Message", type: :string, in: :body, required: true
    parameter :loyalty_program_id, "Id of loyalty program", type: :integer, in: :body
    parameter :company_id, "Company id", type: :integer, required: true

    before do
      @creator = create_creator(create_user)
      @company = create_company(@creator)
      @store = create_store(@creator)
      @operator = create_operator(create_user, @store, @company)
      @program = create_program(@company)
      @customer = create_client(@company)
      @customer.client(@company).loyalty_program = @program
      @customer.client(@company).save
    end
  
    let(:message) { "Test" }
    let(:loyalty_program_id) { @program.id }
    let(:authorization) { @creator.token }
    let(:company_id) { @company.id }


    post "api/v1/sms" do
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
    