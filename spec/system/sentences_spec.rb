require 'rails_helper'

RSpec.describe "Sentences", type: :system do
  let!(:user){ create(:user, :admin) }
  let!(:site){ create(:site) }
  let!(:article){ create(:article) }
  before { sign_in_as(user)}
  describe 'センテンスブロックを追加' do
    context '文章が入力されていない' do
      it 'プレビューが表示される' do
        visit edit_admin_article_path(article.uuid)
        expect(current_path).to eq edit_admin_article_path(article.uuid)
        click_on "プレビュー"
        switch_to_window(windows.last)
        expect(current_path).to eq admin_article_preview_path(article.uuid)
        expect(page).to have_content( article.title )
      end
    end
  end
end
