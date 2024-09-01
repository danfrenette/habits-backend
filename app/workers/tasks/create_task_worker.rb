module Tasks
  class CreateTaskWorker < SidekiqJob
    def perform(task_id)
      task = Task.find(task_id)
      Tasks::CreateTaskAssignments.call(task)
    end
  end
end
