require 'acceptance_helper'

resource "Create order" do
  header 'Content-Type', 'application/json'
  header "Authorization", :authorization

  post "api/v1/orders" do
    parameter :user_id, "Id of client", type: :integer, in: :body, required: true
    parameter :price, "Price in cents", minmum: 1, maximum: 100000000, type: :integer, in: :body, required: true
    parameter :use_points, "Last name",  type: :boolean, in: :body, required: true

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

    let(:user_id) { @customer.id }
    let(:authorization) { @operator.token }

    context "Success" do
      let(:price) { 10000 }
      let(:use_points) { false }

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

    context "User not found" do
      let(:user_id) { 0 }

      let(:raw_post) { params.to_json }

      example "User not found" do
        do_request
        expect(status).to eq(404)
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

resource "Get order points info" do
  header 'Content-Type', 'application/json'
  header "Authorization", :authorization

  get "api/v1/orders/points" do
    parameter :user_id, "Id of client", type: :integer, required: true
    parameter :price, "Price in cents", minmum: 1, maximum: 100000000, type: :integer, required: true
    parameter :use_points, "Last name",  type: :boolean, required: true

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

    let(:user_id) { @customer.id }
    let(:authorization) { @operator.token }

    context "Success" do
      let(:price) { 10000 }
      let(:use_points) { false }

      let(:raw_post) { params.to_json }

      example "Success" do
        do_request
        expect(status).to eq(200)
      end
    end

    context "User not found" do
      let(:user_id) { 0 }

      let(:raw_post) { params.to_json }

      example "User not found" do
        do_request
        expect(status).to eq(404)
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

