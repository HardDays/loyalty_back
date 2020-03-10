resource "Create telegram group" do
    header 'Content-Type', 'application/json'
    header "Authorization", :authorization
  
    post "api/v1/telegram/groups" do  
      parameter :join_points, "Join", type: :integer, minmum: 0, maximum: 10000000000, in: :body, required: true

      parameter :company_id, "Company id", type: :integer, required: true

      before do
        @user = create_creator(create_user)
        @company = create_company(@user)
      end
  
      let(:authorization) { @user.token }
      let(:company_id) { @company.id }
  
      context "Success" do
        let(:join_points) { 1000 }
  
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
  
      context "User is not creator" do
        before do
          @wrong_user = create_user
        end
  
        let(:authorization) { @wrong_user.token }
        let(:raw_post) { params.to_json }
  
        example "User is not creator" do
          do_request
          expect(status).to eq(403)
        end
      end
    end
end
  