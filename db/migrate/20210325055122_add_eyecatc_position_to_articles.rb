class AddEyecatcPositionToArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :eyecatch_position, :integer, default: 0
  end
end
