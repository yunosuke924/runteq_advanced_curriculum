require 'rails_helper'

RSpec.describe 'AdminArticlesEmbeddedMedia', type: :system do
  let(:admin) {create(:user, :admin)}
  let(:article) {create :article}

  describe '記事の埋め込みブロックを追加' do
    before do
      login(admin)
      article
      visit edit_admin_article_path(article.uuid)
      click_on('ブロックを追加する')
      click_on('埋め込み')
      click_on('編集')
    end

    context 'YouTubeを選択しアップロード' do
      it 'プレビューした記事にYouTubeが埋め込まれていること', js: true do
        select 'YouTube', from: 'embed[embed_type]'
        fill_in 'ID', with: 'https://youtu.be/dZ2dcC4OnQE'
        page.all('.box-footer')[0].click_button('更新する')
        click_on('プレビュー')
        switch_to_window(windows.last)
        expect(current_path).to eq(admin_article_preview_path(article.uuid)), '更新した記事を正しくプレビューできていません'
        expect(page).to have_selector("iframe[src='https://www.youtube.com/embed/dZ2dcC4OnQE']"), 'プレビューした記事にYouTubeのコンテンツが埋め込まれません'
      end
    end

    context 'Twitterを選択しアップロード' do
      it 'プレビューした記事にTwitterが埋め込まれていること', js: true do
        select 'Twitter', from: 'embed[embed_type]'
        fill_in 'ID', with: 'https://twitter.com/_RUNTEQ_/status/1219795644807667712'
        page.all('.box-footer')[0].click_button('更新する')
        sleep 1 # Json parce処理でUPDATE完了前にプレビューしないよう待機
        click_on('プレビュー')
        switch_to_window(windows.last)
        expect(current_path).to eq(admin_article_preview_path(article.uuid)), '更新した記事を正しくプレビューできていません'
        # embedded_urlだと検証しづらいので固定値で確認
        # expect(page).to have_selector("iframe[src='#{embedded_url_twitter}']")
        sleep 2 # 全体テスト実行時に画面遷移が追いつかないので待機
        expect(page).to have_selector(".twitter-tweet"), 'プレビューした記事にTwitterのコンテンツが埋め込まれません'
      end
    end
  end
end
