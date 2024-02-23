json.array! @habits do |habit|
  json.call(habit, :id, :name, :current)
end
