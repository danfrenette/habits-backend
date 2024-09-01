class RenameCompletionsToAssignments < ActiveRecord::Migration[7.1]
  def change
    rename_table :task_completions, :task_assignments
  end
end
