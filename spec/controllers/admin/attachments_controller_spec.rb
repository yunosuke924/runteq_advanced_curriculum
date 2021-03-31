require 'rails_helper'

RSpec.describe Admin::AttachmentsController, type: :controller do

  describe "GET #destory" do
    it "returns http success" do
      get :destory
      expect(response).to have_http_status(:success)
    end
  end

end
