class EditLikeTableForeignKeyRequired < ActiveRecord::Migration[7.0]
  def change
    change_table :likes do |t|
      t.remove :post_id
      t.remove :comment_id
      t.references :post, null: true,foreign_key: true
      t.references :comment, null: true,foreign_key: true
    end
  end
end