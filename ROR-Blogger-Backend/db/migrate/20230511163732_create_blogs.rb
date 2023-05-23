class CreateBlogs < ActiveRecord::Migration[7.0]
  def change
    create_table :blogs do |t|
      t.string :title
      t.string :content
      t.string :views
      t.string :likes
      t.string :dislikes
      t.string :age_rating
      t.string :user_id
      t.string :topic_id

      t.timestamps
    end
  end
end
