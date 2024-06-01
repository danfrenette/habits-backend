class AddDueAtToTaskCompletion < ActiveRecord::Migration[7.1]
  def change
    add_column :task_completions, :due_at, :datetime, null: false
  end
end
