require 'rails_helper'

RSpec.describe "ArticlesEmbededMedia", type: :system do
  let!(:site){ create(:site) }
  let!(:article) { create :article }
  let(:admin) { create :user, :admin }

  before do
    sign_in_as (admin)
    visit admin_articles_path
    click_link '編集', href: edit_admin_article_path(article.uuid)
    click_on "ブロックを追加する"
    click_on "埋め込み"
    click_on "編集"
  end

  describe '記事編集画面でブロックを追加' do
      context 'Twitterを埋め込み' do
        fit 'Twiterの投稿が記事に埋め込まれている' do
          select "Twitter", from: "embed[embed_type]"
          fill_in 'ID', with: 'https://twitter.com/_RUNTEQ_/status/1219795644807667712'
          within first('.box-footer') do
            click_on "更新する"
          end
          sleep(1)
          click_on 'プレビュー'
          switch_to_window(windows.last)
          expect(current_path).to eq(admin_article_preview_path(article.uuid))
          sleep(2)
          expect(page).to have_selector('.twitter-tweet')
        end

        fit 'Twitterアイコンが表示されている' do
          select "Twitter", from: 'embed[embed_type]'
          fill_in 'ID', with: 'https://twitter.com/_RUNTEQ_/status/1219795644807667712'
          within first('.box-footer') do
            click_on "更新する"
          end
          expect(page).to have_css('.fa-twitter')
        end
      end

    context 'Youtubeを埋め込み' do
      fit 'YouTubeアイコンが表示されている' do
        select "YouTube", from: 'embed[embed_type]'
        fill_in 'ID', with: 'https://youtu.be/g44sfv5KGwo'
        within first('.box-footer') do
          click_on "更新する"
        end
        expect(page).to have_css('.fa-youtube-play')
      end
      fit 'Youtubeの投稿が記事に埋め込まれている' do
        select "YouTube", from: "embed[embed_type]"
          fill_in 'ID', with: 'https://youtu.be/g44sfv5KGwo'
          within first('.box-footer') do
            click_on "更新する"
          end
          sleep(1)
          click_on 'プレビュー'
          switch_to_window(windows.last)
          expect(current_path).to eq(admin_article_preview_path(article.uuid))
          sleep(2)
          expect(page).to have_selector("iframe[src='https://www.youtube.com/embed/g44sfv5KGwo']")
        end
    end
  end
end
