class CreateArticles < ActiveRecord::Migration[6.1]
  def change
    create_table :articles do |t|
      t.string :title
      t.string :subTitle
      t.string :image
      t.string :caption
      t.string :paragraph

      t.timestamps
    end
  end
end
