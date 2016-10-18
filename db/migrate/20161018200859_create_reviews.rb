class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :rating
      t.string :title
      t.text :description
      t.reference :product
      t.belongs_to :product, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
