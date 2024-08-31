json.call(
  task,
  :id,
  :recurring,
  :status,
  :title,
  :slug
)

json.recurrence_rule do
  json.rrule task.recurrence_rule.rrule if task.recurrence_rule.present?
end
