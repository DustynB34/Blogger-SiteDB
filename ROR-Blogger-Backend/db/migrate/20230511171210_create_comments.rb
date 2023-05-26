class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.string :content
      t.bigint :likes
      t.bigint :dislikes
      t.references :user, foreign_key: true
      t.references :blog, foreign_key: true

      t.timestamps
    end
  end
end
