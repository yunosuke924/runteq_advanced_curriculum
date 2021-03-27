require 'rails_helper'

RSpec.describe "ArticleSearches", type: :system do
  describe '検索機能' do
    let!(:site){ create(:site) }

    let!(:user){ create(:user, :admin) }

    let(:article_with_author) { create(:article, :with_author, author_name: '伊藤') }
    let(:article_with_another_author) { create(:article, :with_author, author_name: '鈴木') }
    let(:article_with_tag) { create(:article, :with_tag, tag_name: 'Ruby') }
    let(:article_with_another_tag) { create(:article, :with_tag, tag_name: 'PHP') }
    let(:draft_article_with_sentence) { create(:article, :with_sentence, sentence_body: '基礎編アプリの記事') }
    let(:past_article_with_sentence) { create(:article, :published_article, :with_sentence, sentence_body: '基礎編アプリの記事') }
    let(:future_article_with_sentence) { create(:article, :publish_wait_article, :with_sentence, sentence_body: '基礎編アプリの記事') }
    let(:draft_article_with_another_sentence) { create(:article, :with_sentence, sentence_body: '応用編アプリの記事')}
    let(:past_article_with_another_sentence) { create(:article, :published_article, :with_sentence, sentence_body: '応用編アプリの記事')}
    let(:future_article_with_another_sentence) { create(:article, :publish_wait_article, :with_sentence, sentence_body: '応用編アプリの記事') }

    before { sign_in_as(user) }

    it '著者名で絞り込み検索ができること' do
      # 著者＝伊藤の記事
      article_with_author
      # 著者＝鈴木の記事
      article_with_another_author
      visit admin_articles_path
      within 'select[name="q[author_id]"]' do
        select '伊藤'
        # select '伊藤', from: 'select[name=q[author_id]]' が機能しなかった
      end
      click_button '検索'
      expect(page).to have_content(article_with_author.title), '著者名での検索ができていません'
      expect(page).not_to have_content(article_with_another_author.title), '著者名での絞り込みができていません'
    end

    it 'タグで絞り込み検索ができること' do
      # タグがRubyの記事
      article_with_tag
      # タグがPHPの記事
      article_with_another_tag
      visit admin_articles_path
      within 'select[name="q[tag_id]"]' do
        select 'Ruby'
      end
      click_button '検索'
      expect(page).to have_content(article_with_tag.title), 'タグでの検索ができていません'
      expect(page).not_to have_content(article_with_another_tag.title), 'タグでの絞り込みができていません'
    end

    it '公開状態の記事について、本文で絞り込み検索ができること' do
      visit edit_admin_article_path(past_article_with_sentence.uuid)
      click_on '公開する'
      visit edit_admin_article_path(past_article_with_another_sentence.uuid)
      click_on '公開する'
      visit admin_articles_path
      fill_in 'q[body]', with: '基礎編アプリ'
      click_button '検索'
      expect(page).to have_content(past_article_with_sentence.title), '公開状態の記事について、本文での検索ができていません'
      expect(page).not_to have_content(past_article_with_another_sentence.title), '公開状態の記事について、本文での絞り込みができていません'
    end

    it '公開待ち状態の記事について、本文で絞り込み検索ができること' do
      visit edit_admin_article_path(future_article_with_sentence.uuid)
      click_on '公開する'
      visit edit_admin_article_path(future_article_with_another_sentence.uuid)
      click_on '公開する'
      visit admin_articles_path
      fill_in 'q[body]', with: '基礎編アプリ'
      click_button '検索'
      expect(page).to have_content(future_article_with_sentence.title), '公開待ち状態の記事について、本文での検索ができていません'
      expect(page).not_to have_content(future_article_with_another_sentence.title), '公開待ち状態の記事について、本文での絞り込みができていません'
    end

    it '下書き状態の記事について、本文で絞り込み検索ができること' do
      draft_article_with_sentence
      draft_article_with_another_sentence
      visit admin_articles_path
      fill_in 'q[body]', with: '基礎編アプリ'
      click_button '検索'
      expect(page).to have_content(draft_article_with_sentence.title), '下書き状態の記事について、本文での検索ができていません'
      expect(page).not_to have_content(draft_article_with_another_sentence.title), '下書き状態の記事について、本文での絞り込みができていません'
    end
  end
end
