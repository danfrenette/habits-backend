json.call(
  task_assignment,
  :id,
  :task_id,
  :due_at,
  :completed_at
)
json.task_title task_assignment.task_title
json.task_slug task_assignment.task_slug
