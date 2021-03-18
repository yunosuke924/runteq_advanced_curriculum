namespace :publish do
  desc "公開日が過去の記事を公開"
  task publish_past_articles: :environment do
    @articles = Article.where( state: :publish_wait).where("published_at < ?", Time.current)
    @articles.each do |article|
      article.state = :published
      article.save
    end
  end
end
