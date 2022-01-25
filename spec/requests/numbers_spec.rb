require 'rails_helper'

RSpec.describe "/numbers", type: :request do
  
  let(:valid_attributes) {
    attributes_for(:number)
  }

  let(:valid_headers) {
    {}
  }

  describe "GET /index" do
    it "renders a successful response" do
      Number.create! valid_attributes
      get numbers_url, headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

end
