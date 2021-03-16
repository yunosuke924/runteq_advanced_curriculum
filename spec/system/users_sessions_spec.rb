require 'rails_helper'

RSpec.describe "UsersSessions", type: :system do
  describe 'ログイン前' do
    let!(:user){ create(:user, :admin) }
    let!(:site){ create(:site) }
    context 'ログインページの表示' do
      it 'ログインに成功する' do
        visit admin_login_identifier_path
        fill_in "Username", with: user.name
        click_button "次へ"
        expect(current_path).to eq admin_login_password_path
        fill_in "Password", with: "password"
        click_button "ログイン"
        expect(current_path).to eq admin_dashboard_path
      end
    end
  end 
end
