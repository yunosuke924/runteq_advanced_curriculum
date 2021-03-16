require 'rails_helper'

RSpec.describe "Mediums", type: :system do
  let!(:user){ create(:user, :admin) }
  let!(:site){ create(:site) }
  let!(:article){ create(:article) }
  before { sign_in_as(user)}
  describe 'コンテンツブロックを挿入' do
    context '画像ファイルを添付しない' do
      it 'プレビューが表示される' do
        visit edit_admin_article_path(article.uuid)
        expect(current_path).to eq edit_admin_article_path(article.uuid)
        click_on "ブロックを追加する"
        click_on "画像"
        click_on "プレビュー"
        switch_to_window(windows.last)
        expect(current_path).to eq admin_article_preview_path(article.uuid)
      end
      it '公開ページが表示される' do
        visit edit_admin_article_path(article.uuid)
        expect(current_path).to eq edit_admin_article_path(article.uuid)
        click_on "ブロックを追加する"
        click_on "画像"
        click_on "公開する"
        expect(current_path).to eq edit_admin_article_path(article.uuid)
        expect(page).to have_content "記事を公開しました"
      end
    end

    content '画像ファイルを添付する' do
      it 'プレビューが表示される'
      it '公開ページが表示される'
    end
  end
end
