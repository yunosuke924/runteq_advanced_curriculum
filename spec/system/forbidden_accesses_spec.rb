require 'rails_helper'

RSpec.describe "ForbiddenAccesses", type: :system do
  let!(:writer){ create(:user) }
  let(:editor) { create(:user, :editor) }
  let(:admin) { create(:user, :admin) }
  let!(:site){ create(:site) }
  let!(:article){ create(:article) }
  let!(:tag){ create(:tag) }
  let!(:category){ create(:category) }
  let!(:author){ create(:author) }

  before { driven_by(:rack_test) }

  describe 'ライターに関するアクセス権限' do
    before { sign_in_as(writer)}
    context 'サイドバーメニューにアクセス' do
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

    context '制限されたページにダイレクトにアクセス' do
      context 'タグ一覧ページ' do
        it '403エラーが表示される' do
          visit admin_tags_path
          expect(page).to have_http_status(403), 'ライターがタグ一覧ページのアクセスに成功しています'
          expect(page).not_to have_selector("input[value=#{tag.name}]"), 'タグ一覧ページの内容がライターに表示されています'
        end
      end
      context 'タグ編集ページ' do
        it '403エラーが表示される' do
          visit edit_admin_tag_path(tag)
          expect(page).to have_http_status(403), 'ライターがタグ編集ページのアクセスに成功しています'
          expect(page).not_to have_selector("input[value=#{tag.name}]"), 'タグ編集ページの内容がライターに表示されています'
        end
      end
      context 'カテゴリ一覧ページ' do
        it '403エラーが表示される' do
          visit admin_categories_path
          expect(page).to have_http_status(403), 'ライターがカテゴリー一覧ページのアクセスに成功しています'
          expect(page).not_to have_content(category.name), 'カテゴリー一覧ページの内容がライターに表示されています'
        end
      end
      context 'カテゴリ編集ページ' do
        it '403エラーが表示される' do         
          visit edit_admin_category_path(category)
          expect(page).to have_http_status(403), 'ライターがカテゴリー編集ページのアクセスに成功しています'
          expect(page).not_to have_selector("input[value=#{category.name}]"), 'カテゴリー編集ページの内容がライターに表示されています'
        end
      end
      context '著者一覧ページ' do
        it '403エラーが表示される' do
          visit admin_authors_path
         expect(page).to have_http_status(403), 'ライターが著者一覧ページのアクセスに成功しています'
         expect(page).not_to have_content(author.name), '著者一覧ページの内容がライターに表示されています'
        end
      end
      context '著者編集ページ' do
        it '403エラーが表示される' do
          visit edit_admin_author_path(author)
          expect(page).to have_http_status(403), 'ライターが著者編集ページのアクセスに成功しています'
          expect(page).not_to have_selector("input[value=#{author.name}]"), '著者編集ページの内容がライターに表示されています'
        end
      end
    end
  end

  describe '編集者に関するアクセス権限' do
    before { sign_in_as(editor)}
    context 'サイドバーメニューにアクセス' do
      it 'タグのリンクが表示されること' do
        visit admin_dashboard_path
        within('.sidebar-menu') do
          expect(page).to have_content("タグ")
        end
      end
      it 'カテゴリーのリンクが表示されること' do
        visit admin_dashboard_path
        within('.sidebar-menu') do
          expect(page).to have_content("カテゴリー")
        end
      end
      it '著者のリンクが表示されること' do
        visit admin_dashboard_path
        within('.sidebar-menu') do
          expect(page).to have_content("著者")
        end
      end
    end

    context '制限付きページにダイレクトにアクセス' do
      context 'タグ一覧ページ' do
        it 'タグ一覧が表示される' do
          visit admin_tags_path
          expect(page).to have_http_status(200), '編集者がタグ一覧ページのアクセスに失敗しています'
          expect(page).to have_content(tag.name), 'タグ一覧ページの内容が編集者に表示されていません'
        end
      end
      context 'タグ編集ページ' do
        it 'タグ編集ページが表示される' do
          visit edit_admin_tag_path(tag)
          expect(page).to have_http_status(200), '編集者がタグ編集ページのアクセスに失敗しています'
          expect(page).to have_selector("input[value=#{tag.name}]"), 'タグ編集ページの内容が編集者に表示されていません'
        end
      end
      context 'カテゴリ一覧ページ' do
        it 'カテゴリ一覧ページが表示される' do
          visit admin_categories_path
          expect(page).to have_http_status(200), '編集者がカテゴリー一覧ページのアクセスに失敗しています'
          expect(page).to have_content(category.name), 'カテゴリー一覧ページの内容が編集者に表示されていません'
        end
      end
      context 'カテゴリ編集ページ' do
        it 'カテゴリ編集ページが表示される' do
          visit edit_admin_category_path(category)
          expect(page).to have_http_status(200), '編集者がカテゴリー編集ページのアクセスに失敗しています'
          expect(page).to have_selector("input[value=#{category.name}]"), 'カテゴリー編集ページの内容が編集者に表示されていません'
        end
      end
      context '著者一覧ページ' do
        it '著者一覧ページが表示される' do
          visit admin_authors_path
          expect(page).to have_http_status(200), '編集者が著者一覧ページのアクセスに失敗しています'
          expect(page).to have_content(author.name), '著者一覧ページの内容が編集者に表示されていません'
        end
      end
      context '著者編集ページ' do
        it '著者編集ページが表示される' do
          visit edit_admin_author_path(author)
          expect(page).to have_http_status(200), '編集者が著者編集ページのアクセスに失敗しています'
          expect(page).to have_selector("input[value=#{author.name}]"), '著者編集ページの内容が編集者に表示されていません'
        end
      end
    end
  end

  describe '管理者に関するアクセス権限' do
    before { sign_in_as(admin)}
    context 'サイドバーメニューにアクセス' do
      it 'タグのリンクが表示されること' do
        visit admin_dashboard_path
        within('.sidebar-menu') do
          expect(page).to have_content("カテゴリー")
        end
      end
      it 'カテゴリーのリンクが表示されること' do
        visit admin_dashboard_path
        within('.sidebar-menu') do
          expect(page).to have_content("カテゴリー")
        end
      end
      it '著者のリンクが表示されること' do
        visit admin_dashboard_path
        within('.sidebar-menu') do
          expect(page).to have_content("著者")
        end
      end
    end

    context '制限付きページにダイレクトにアクセス' do
      context 'タグ一覧ページ' do
        it 'タグ一覧が表示される' do
          visit admin_tags_path
          expect(page).to have_http_status(200), '編集者がタグ一覧ページのアクセスに失敗しています'
          expect(page).to have_content(tag.name), 'タグ一覧ページの内容が編集者に表示されていません'
        end
      end
      context 'タグ編集ページ' do
        it 'タグ編集ページが表示される' do
          visit edit_admin_tag_path(tag)
          expect(page).to have_http_status(200), '編集者がタグ編集ページのアクセスに失敗しています'
          expect(page).to have_selector("input[value=#{tag.name}]"), 'タグ編集ページの内容が編集者に表示されていません'
        end
      end
      context 'カテゴリ一覧ページ' do
        it 'カテゴリ一覧ページが表示される' do
          visit admin_categories_path
          expect(page).to have_http_status(200), '編集者がカテゴリー一覧ページのアクセスに失敗しています'
          expect(page).to have_content(category.name), 'カテゴリー一覧ページの内容が編集者に表示されていません'
        end
      end
      context 'カテゴリ編集ページ' do
        it 'カテゴリ編集ページが表示される' do
          visit edit_admin_category_path(category)
          expect(page).to have_http_status(200), '編集者がカテゴリー編集ページのアクセスに失敗しています'
          expect(page).to have_selector("input[value=#{category.name}]"), 'カテゴリー編集ページの内容が編集者に表示されていません'
        end
      end
      context '著者一覧ページ' do
        it '著者一覧ページが表示される' do
          visit admin_authors_path
          expect(page).to have_http_status(200), '編集者が著者一覧ページのアクセスに失敗しています'
          expect(page).to have_content(author.name), '著者一覧ページの内容が編集者に表示されていません'
        end
      end
      context '著者編集ページ' do
        it '著者編集ページが表示される' do
          visit edit_admin_author_path(author)
          expect(page).to have_http_status(200), '編集者が著者編集ページのアクセスに失敗しています'
          expect(page).to have_selector("input[value=#{author.name}]"), '著者編集ページの内容が編集者に表示されていません'
        end
      end
    end
  end
end
