require 'acceptance_helper'

resource "Authorization" do
  post "/auth/login" do


    attribute :email, "Email (need if not phone)", type: :string, required: true
    attribute :phone, "Phone (need if not email)", type: :string, required: true
    attribute :password, "Password", type: :string, required: true


    example "Login", :document => :private do
      #do_request(email: "eric@example.com", password: '123123123')
      #status.should == 403
      # expect(response_body).to eq({name: '1'})
      # expect(status).to eq(201)
    end
    
  end
end
