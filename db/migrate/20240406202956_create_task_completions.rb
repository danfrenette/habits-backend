class CreateTaskCompletions < ActiveRecord::Migration[7.1]
  def change
    create_table :task_completions, id: :uuid do |t|
      t.references :task, null: false, foreign_key: true, type: :uuid, index: true
      t.datetime :completed_at, null: false
      t.text :notes
      t.boolean :completed, null: false, default: false

      t.timestamps
    end
  end
end
