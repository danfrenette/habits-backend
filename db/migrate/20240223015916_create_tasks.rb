class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks, id: :uuid do |t|
      t.string :title
      t.string :status, null: false, default: "pending"
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :response, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
