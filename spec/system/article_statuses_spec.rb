require 'rails_helper'

RSpec.describe "ArticleStatuses", type: :system do
  let!(:user){ create(:user, :admin) }
  let!(:site){ create(:site) }
  let!(:article){ create(:article) }
  before { sign_in_as(user)}
  describe '記事編集画面' do
    describe '「更新する」時に' do
      describe 'ステータスが「公開」' do
        let!(:article){ create(:article, :published_article) }

        context '公開日時が過去' do
          it 'ステータスは「公開」になる' do
            visit edit_admin_article_path(article.uuid)
            click_on "更新する"
            expect(page).to have_select('状態', selected: '公開')
          end
        end

        context '公開日時が未来' do
          it 'ステータスは「公開待ち」になる' do
            visit edit_admin_article_path(article.uuid)
            fill_in '公開日', with: Time.current.tomorrow
            click_on "更新する"
            expect(page).to have_select('状態', selected: '公開待ち')
          end
        end
      end

      describe 'ステータスが「公開待ち」' do
        let!(:article){ create(:article, :publish_wait_article) }

        context '公開日時が過去' do
          it 'ステータスは「公開」になる' do
            visit edit_admin_article_path(article.uuid)
            fill_in '公開日', with: Time.current.yesterday
            click_on "更新する"
            expect(page).to have_select('状態', selected: '公開')
          end
        end 

        context '公開日時が未来' do
          it 'ステータスは「公開待ち」になる' do
            visit edit_admin_article_path(article.uuid)
            click_on "更新する"
            expect(page).to have_select('状態', selected: '公開待ち')
          end
        end
      end

      describe 'ステータスが「下書き」の時' do
        it 'ステータスは「下書き」のまま' do
          visit edit_admin_article_path(article.uuid)
          click_on "更新する"
          expect(find('.form-control', match: :first)).to have_content('下書き')
        end
      end
    end

    describe '「公開する」とき' do
      context '公開日時が未来' do
        it 'ステータスが「公開待ち」になる' do
          visit edit_admin_article_path(article.uuid)
          fill_in '公開日', with: Time.current.tomorrow
          click_on "更新する"
          click_on "公開する"
          expect(page).to have_select('状態', selected: '公開待ち')
        end
      end

      context '公開日時が過去' do
        it 'ステータスが「公開」になる' do
          visit edit_admin_article_path(article.uuid)
          fill_in '公開日', with: Time.current.yesterday
          click_on "更新する"
          click_on "公開する"
          expect(page).to have_select('状態', selected: '公開')
        end
      end
    end
  end
end
