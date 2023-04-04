require 'rails_helper'

RSpec.describe "Portcurio", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get portcurio_index_path
      expect(response).to have_http_status(:success)
    end
  end

end
