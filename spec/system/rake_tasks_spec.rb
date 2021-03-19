require 'rake_helper'

RSpec.describe "RakeTasks", type: :system do
  describe 'publish:publish_past_articles' do
    subject(:task) { Rake.application['publish:publish_past_articles'] }
    before do
      create(:article, state: :publish_wait, published_at: Time.current - 1.day)
      create(:article, state: :publish_wait, published_at: Time.current + 1.day)
      create(:article, state: :draft)
    end

    xit '公開日時が過去の記事のステータスを公開にする' do
      expect { task.invoke }.to change { Article.published.size }.from(0).to(1)
    end
  end
end
