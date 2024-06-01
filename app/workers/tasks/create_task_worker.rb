module Tasks
  class CreateTaskWorker < SidekiqJob
    def perform(task_id)
      task = Task.find(task_id)
      Tasks::CreateTaskCompletions.call(task)
    end
  end
end
