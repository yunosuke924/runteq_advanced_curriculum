class AddEyecatchWidthToArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :eyecatch_width, :integer, default: 100
  end
end
