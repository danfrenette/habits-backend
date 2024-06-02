class TaskCompletion < ApplicationRecord
  belongs_to :task

  validates :due_at, presence: true
  validates :task_id, uniqueness: {scope: :due_at}

  delegate :title, to: :task, prefix: true
end
