class ArticleMailer < ApplicationMailer
  default from: 'from@example.com'

  def report_summary
    @articles = Article.where(published_at: Date.yesterday.in_time_zone.all_day)
    mail(to: 'admin@example.com', subject: '公開済記事の集計結果')
  end
end
