class SearchArticlesForm
  # FromObject
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :category_id, :integer
  attribute :tag_id, :integer
  attribute :author_id, :integer
  attribute :title, :string
  attribute :body, :string

  # 検索処理
  def search
    relation = Article.distinct

    # もし記事にカテゴリーが設定されていれば、記事のカテゴリー属性を付与
    relation = relation.by_category(category_id) if category_id.present?
    # 与えられた文字列を含むタイトルを返す
    title_words.each do |word|
      relation = relation.title_contain(word)
    end
    # タグが与えられていれば付与
    relation = relation.by_tag(tag_id) if tag_id.present?
    # 著者が与えられていれば付与
    relation = relation.by_author(author_id) if author_id.present?
    # 本文が与えられていれば付与
    # body_words.each do |word|
    #   relation = relation.body_contain(word)
    # end
    # 本文が与えられていれば付与(改変)
    body_words.each do |word|
      relation = relation.body_has(word)
    end

    relation
  end

  private

  def title_words
    title.present? ? title.split(nil) : []
  end

  def body_words
    body.present? ? body.split(nil) : []
  end
end
