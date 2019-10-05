resource "Sms report" do
    header 'Content-Type', 'application/json'
    header "Authorization", :authorization
    
    parameter :message, "Message", type: :string, in: :body, required: true
    parameter :loyalty_program_id, "Id of loyalty program", type: :integer, in: :body

    before do
      @creator = create_creator(create_user)
      @company = create_company(@creator)
      @store = create_store(@creator)
      @operator = create_operator(create_user, @store, @company)
      @program = create_program(@company)
      @customer = create_client(@company)
      @customer.client.loyalty_program = @program
      @customer.client.save
    end
  
    let(:message) { "Test" }
    let(:loyalty_program_id) { @program.id }
    let(:authorization) { @creator.token }

    let(:raw_post) { params.to_json }

    post "api/v1/sms" do
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
    end
  end
    