# resource "List tariff plans" do
#   header 'Content-Type', 'application/json'
#   header "Authorization", :authorization

#   get "api/v1/tariff_plans" do

#     before do
#       @tariff_plan = create_tariff_plan
#     end

#     example "Success" do
#       do_request
#       expect(status).to eq(200)
#     end
   
#   end
# end

# resource "Purchase tariff plan" do
#   header 'Content-Type', 'application/json'
#   header "Authorization", :authorization

#   post "api/v1/tariff_plans/purchase" do
#     parameter :tariff_plan_id, "Tariff plan id", type: :integer, in: :body, required: true

#     before do
#       @creator = create_creator(create_user)
#       @company = create_company(@creator)
#       @tariff_plan = create_tariff_plan
#     end

#     let(:tariff_plan_id) { @tariff_plan.id }
#     let(:authorization) { @creator.token }

#     context "Success" do
#       let(:raw_post) { params.to_json }

#       example "Success" do
#         do_request
#         expect(status).to eq(200)

#         expect(@company.reload.tariff_plan_purchase.tariff_plan_id).to eq(@tariff_plan.id)
#       end
#     end

#     context "Not found" do
#       let(:tariff_plan_id) { 0 }

#       let(:raw_post) { params.to_json }

#       example "Not found" do
#         do_request
#         expect(status).to eq(404)
#       end
#     end

#     context "Wrong token" do
#       let(:authorization) { "test" }
#       let(:raw_post) { params.to_json }

#       example "Wrong token" do
#         do_request
#         expect(status).to eq(401)
#       end
#     end

#     context "User is not creator" do
#       before do
#         @wrong_creator = create_user
#       end

#       let(:authorization) { @wrong_creator.token }
#       let(:raw_post) { params.to_json }

#       example "User is not creator" do
#         do_request
#         expect(status).to eq(403)
#       end
#     end
#   end
# end
