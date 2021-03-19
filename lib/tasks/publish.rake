namespace :publish do
  desc "公開日が過去の記事を公開"
  task publish_past_articles: :environment do
    Article.publish_wait.past_published.find_each(&:published!)
    # @articles = Article.where( state: :publish_wait).where("published_at < ?", Time.current)
    # @articles.each do |article|
    #   article.state = :published
    #   article.save
  end

  task test: :environment do
    time_now = Time.current
    time = Time.local(2021,3,19,21,00,00)
    puts "#{((time_now - time)/60).to_i}分が経過しました"
  end
end
