class AddRecurrenceColumnsToTasks < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :end_recurrence_at, :datetime
    add_column :tasks, :recurring, :boolean, default: false, null: false
  end
end
