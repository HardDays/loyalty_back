resource "General report" do
  header 'Content-Type', 'application/json'
  header "Authorization", :authorization

  parameter :begin_date, "Begin date (in format 21.09.2019)", type: :string
  parameter :end_date, "End date (in format 21.09.2019)", type: :string
  parameter :stores, "Store ids", type: :array, items: {type: :integer}
  parameter :loyalty_programs, "Loyalty progams ids", type: :array, items: {type: :integer}
  parameter :operators, "Operators ids", type: :array, items: {type: :integer}

  before do
    @creator = create_creator(create_user)
    @company = create_company(@creator)
    @store = create_store(@creator)
    @operator = create_operator(create_user, @store, @company)
    @program = create_program(@company)
  end

  let(:authorization) { @creator.token }

  get "api/v1/reports/general" do
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
  
resource "Orders report" do
  header 'Content-Type', 'application/json'
  header "Authorization", :authorization

  parameter :begin_date, "Begin date (in format 21.09.2019)", type: :string
  parameter :end_date, "End date (in format 21.09.2019)", type: :string
  parameter :stores, "Store ids", type: :array, items: {type: :integer}
  parameter :loyalty_programs, "Loyalty progams ids", type: :array, items: {type: :integer}
  parameter :operators, "Operators ids", type: :array, items: {type: :integer}
  parameter :limit, "Limit", type: :integer
  parameter :offset, "Offset", type: :integer
  
  before do
    @creator = create_creator(create_user)
    @company = create_company(@creator)
    @store = create_store(@creator)
    @operator = create_operator(create_user, @store, @company)
    @program = create_program(@company)
    @customer = create_client(@company)
    @customer.client.loyalty_program = @program
    @customer.client.save

    @order = Order.new(price: 5000)
    @order.operator = @operator.operator
    @order.client = @customer.client
    @order.loyalty_program = @program
    @order.store = @store 
    @order.write_off_status = :not_written_off
    @order.save

    ClientPointsHelper.create_from_program(@customer.client, @order, @program, nil)
  end

  # let(:stores) { [@store.id] }
  # let(:loyalty_programs) { [@program.id] }
  # let(:operators) { [@operator.id] }
  let(:authorization) { @creator.token }

  get "api/v1/reports/orders" do
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

resource "Clients report" do
  header 'Content-Type', 'application/json'
  header "Authorization", :authorization

  parameter :begin_date, "Begin date (in format 21.09.2019)", type: :string
  parameter :end_date, "End date (in format 21.09.2019)", type: :string
  parameter :stores, "Store ids", type: :array, items: {type: :integer}
  parameter :loyalty_programs, "Loyalty progams ids", type: :array, items: {type: :integer}
  parameter :operators, "Operators ids", type: :array, items: {type: :integer}
  parameter :limit, "Limit", type: :integer
  parameter :offset, "Offset", type: :integer
  
  before do
    @creator = create_creator(create_user)
    @company = create_company(@creator)
    @store = create_store(@creator)
    @operator = create_operator(create_user, @store, @company)
    @program = create_program(@company)
    @customer = create_client(@company)
    @customer.client.loyalty_program = @program
    @customer.client.save

    @order = Order.new(price: 5000)
    @order.operator = @operator.operator
    @order.client = @customer.client
    @order.loyalty_program = @program
    @order.store = @store 
    @order.write_off_status = :not_written_off
    @order.save
    
    ClientPointsHelper.create_from_program(@customer.client, @order, @program, nil)
  end

  let(:authorization) { @creator.token }

  get "api/v1/reports/clients" do
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
  
resource "Sms report" do
  header 'Content-Type', 'application/json'
  header "Authorization", :authorization
  
  parameter :begin_date, "Begin date (in format 21.09.2019)", type: :string
  parameter :end_date, "End date (in format 21.09.2019)", type: :string
  parameter :stores, "Store ids", type: :array, items: {type: :integer}
  parameter :loyalty_programs, "Loyalty progams ids", type: :array, items: {type: :integer}
  parameter :operators, "Operators ids", type: :array, items: {type: :integer}

  before do
    @creator = create_creator(create_user)
    @company = create_company(@creator)
    @store = create_store(@creator)
    @operator = create_operator(create_user, @store, @company)
    @program = create_program(@company)
  end

  let(:authorization) { @creator.token }

  get "api/v1/reports/sms" do
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
  