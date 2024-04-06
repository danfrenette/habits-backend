class TaskCompletion < ApplicationRecord
  belongs_to :task

  validates :completed_at, presence: true
  validates :task_id, uniqueness: {scope: :completed_at}
end
