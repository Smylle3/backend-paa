class AddTextReadyToArticles < ActiveRecord::Migration[6.1]
  def change
    add_column :articles, :textReady, :string
  end
end
