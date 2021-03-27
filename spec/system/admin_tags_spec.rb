require 'rails_helper'

RSpec.describe "AdminTags", type: :system do
  let!(:site){ create(:site) }
  let!(:user){ create(:user, :admin) }
  before { sign_in_as(user) }
  describe 'タグ一覧画面' do
    it 'パンクズが表示されている' do
      visit admin_tags_path
      within ('.breadcrumb') do
        expect(page).to have_content('Home')
        expect(page).to have_content('タグ')
      end
    end
    it 'パンクズのhomeのリンクに遷移する' do
      visit admin_tags_path
      within('.breadcrumb') do
        click_link 'Home'
      end
      expect(current_path).to eq(admin_dashboard_path)
    end
  end
  describe 'タグ編集画面' do
    let!(:tag){ create(:tag) }
    it 'パンクズが表示されている' do
      visit edit_admin_tag_path(tag)
      within('.breadcrumb') do
        expect(page).to have_content('Home')
        expect(page).to have_content('タグ')
        expect(page).to have_content('タグ編集')
      end
    end

    it 'パンクズのタグに遷移する' do
      visit edit_admin_tag_path(tag)
      within('.breadcrumb') do
        click_link 'タグ'
      end
      expect(current_path).to eq(admin_tags_path)
    end
  end
end
