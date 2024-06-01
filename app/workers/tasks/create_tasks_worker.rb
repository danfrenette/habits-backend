module Tasks
  class CreateTasksWorker < SidekiqJob
    def perform
      Task.actively_recurring.find_each do |task|
        CreateTaskWorker.perform_async(task.id)
      end
    end
  end
end
