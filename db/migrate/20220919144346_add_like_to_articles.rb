class AddLikeToArticles < ActiveRecord::Migration[6.1]
  def change
    add_column :articles, :like, :string
  end
end
