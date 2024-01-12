class CreateHabits < ActiveRecord::Migration[7.1]
  def change
    create_table :habits, id: :uuid do |t|
      t.string :name, null: false
      t.boolean :current, null: false
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end

    add_index :habits, [:name, :user_id], unique: true
  end
end
