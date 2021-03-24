require 'rails_helper'

RSpec.describe "ForbiddenAccesses", type: :system do
  let!(:user){ create(:user) }
  let!(:site){ create(:site) }
  let!(:article){ create(:article) }
  let!(:tag){ create(:tag) }

  before { sign_in_as(user)}

  describe 'ダッシュボード' do
    describe 'サイドバーメニューに' do
      it 'タグのリンクが表示されないこと' do
        visit admin_dashboard_path
        within('.sidebar-menu') do
          expect(page).not_to have_content("タグ")
        end
      end
      it 'カテゴリーのリンクが表示されないこと' do
        visit admin_dashboard_path
        within('.sidebar-menu') do
          expect(page).not_to have_content("カテゴリー")
        end
      end
      it '著者のリンクが表示されないこと' do
        visit admin_dashboard_path
        within('.sidebar-menu') do
          expect(page).not_to have_content("著者")
        end
      end
    end
    describe '直接アクセスしようとした時' do
      it 'エラーページが表示される' do
        visit admin_tags_path
        expect(page).to have_content("403エラーです。")
      end
    end
  end
end
