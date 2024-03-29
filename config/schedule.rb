# Rails.rootを使用するために必要。なぜなら、wheneverは読み込まれるときにrailsを起動する必要がある
require File.expand_path(File.dirname(__FILE__) + "/environment")
# cronを実行する環境変数
rails_env = ENV['RAILS_ENV'] || :development
# cronを実行する環境変数をセット
set :environment, rails_env

# cronのログの吐き出し場所。ここでエラー内容を確認する
set :output, "#{Rails.root}/log/cron.log"

every 1.hours do
  # command "/usr/bin/some_great_command"
  # runner "MyModel.some_method"
  rake "publish:publish_past_articles"
end

every 1.minute do
  # command "/usr/bin/some_great_command"
  # runner "MyModel.some_method"
  rake "publish:test"
end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
