# == Schema Information
#
# Table name: articles
#
#  id           :bigint           not null, primary key
#  category_id  :bigint
#  author_id    :bigint
#  uuid         :string(255)
#  slug         :string(255)
#  title        :string(255)
#  description  :text(65535)
#  body         :text(65535)
#  state        :integer          default("draft"), not null
#  published_at :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  deleted_at   :datetime
#
# Indexes
#
#  index_articles_on_author_id     (author_id)
#  index_articles_on_category_id   (category_id)
#  index_articles_on_deleted_at    (deleted_at)
#  index_articles_on_published_at  (published_at)
#  index_articles_on_slug          (slug)
#  index_articles_on_uuid          (uuid)
#

FactoryBot.define do
  factory :article do
    sequence(:title) { |n| "title-#{n}" }
    sequence(:slug) { |n| "slug-#{n}" }
    description { "This is a test description" }
    uuid { "#{SecureRandom.uuid}"}
    association :category
    state { :draft }
    published_at { Time.current }
  end
  # 公開済みの記事
  trait :published_article do
    state { :published }
    published_at { Time.current.yesterday }
  end
  # 公開待ちの記事
  trait :publish_wait_article do
    state { :publish_wait }
    published_at { Time.current.tomorrow }
  end

  #  以下模範解答
  trait :with_author do
    transient do
      sequence(:author_name) { |n| "test_author_name_#{n}" }
      sequence(:tag_slug) { |n| "test_author_slug_#{n}" }
    end
    after(:build) do |article, evaluator|
      article.author = build(:author, name: evaluator.author_name, slug: evaluator.tag_slug)
    end
  end

  trait :with_tag do
    transient do
      sequence(:tag_name) { |n| "test_tag_name_#{n}" }
      sequence(:tag_slug) { |n| "test_tag_slug_#{n}" }
    end

    after(:build) do |article, evaluator|
      article.tags << build(:tag, name: evaluator.tag_name, slug: evaluator.tag_slug)
    end
  end

  trait :with_sentence do
    transient do
      sequence(:sentence_body) { |n| "test_body_#{n}" }
    end

    after(:build) do |article, evaluator|
      article.sentences << create(:sentence, body: evaluator.sentence_body)
    end
  end
end
