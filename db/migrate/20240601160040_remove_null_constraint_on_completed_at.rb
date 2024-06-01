class RemoveNullConstraintOnCompletedAt < ActiveRecord::Migration[7.1]
  def change
    change_column_null :task_completions, :completed_at, true
  end
end
