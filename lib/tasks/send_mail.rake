namespace :send_mail do
  desc "公開済み記事の集計結果をメール送信する"
  task pulished_article: :environment do
    ArticleMailer.report_summary.deliver_now
  end
end
