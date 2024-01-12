json.array! @habits do |habit|
  json.call(patient, :id, :name, :current)
end
