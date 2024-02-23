json.array! @tasks do |task|
  json.call(task, :id, :title, :status)
end
