resource "Create vk group" do
    header 'Content-Type', 'application/json'
    header "Authorization", :authorization
  
    post "api/v1/vk/groups" do
      parameter :group_id, "Vk group id", type: :string, in: :body, required: true
      parameter :confirmation_code, "Confirmation code (use this code for link for callback api: https://fathomless-earth-40434.herokuapp.com/api/test/v1/vk/callback/<company_id>/<code>) ", type: :string, in: :body, required: true
      parameter :group_join_points, "Group join", type: :integer, minmum: 0, maximum: 10000000000, in: :body, required: true
      parameter :wall_repost_points, "Repost", type: :integer, minmum: 0, maximum: 10000000000, in: :body, required: true
      parameter :wall_like_points, "Post like", type: :integer, minmum: 0, maximum: 10000000000, in: :body, required: true
      parameter :wall_reply_points, "Post comment", type: :integer, minmum: 0, maximum: 10000000000, in: :body, required: true

      parameter :company_id, "Company id", type: :integer, required: true

      before do
        @user = create_creator(create_user)
        @company = create_company(@user)
      end
  
      let(:authorization) { @user.token }
      let(:company_id) { @company.id }
  
      context "Success" do
        let(:group_id) { "123" }
        let(:group_join_points) { 1000 }
        let(:wall_repost_points) { 1000 }
        let(:wall_like_points) { 1000 }
        let(:wall_reply_points) { 1000 }

        let(:confirmation_code) { "45857340" }
  
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
  