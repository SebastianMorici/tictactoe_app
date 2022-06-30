# 'boards' migration file
class CreateBoards < ActiveRecord::Migration[7.0]
  def change
    create_table :boards do |t|
      t.string :state, default: " , , , , , , , , "
      t.boolean :full, default: false
      t.string :turn, limit: 1, default: 'x'
      t.integer :winner, default: 0

      t.references :playerx, null: false, foreign_key: { to_table: :players }
      t.references :playero, foreign_key: { to_table: :players }

      t.timestamps
    end
  end
end
