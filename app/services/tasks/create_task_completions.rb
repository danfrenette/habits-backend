module Tasks
  class CreateTaskCompletions
    class TaskNotRecurringError < StandardError; end

    def self.call(task)
      new(task).call
    end

    def initialize(task)
      @task = task
    end

    def call
      raise TaskNotRecurringError if task_is_not_actively_recurring?

      dates.each do |due_date|
        due_at = due_date.in_time_zone(recurrence_rule.time_zone).end_of_day
        TaskCompletion.find_or_create_by!(task: task, due_at: due_at)
      end
    end

    private

    attr_reader :task

    def task_is_not_actively_recurring?
      task.completed? || !task.recurring || task.recurrence_ends_at.present? && task.recurrence_ends_at < Time.current
    end

    def dates
      @dates ||= recurrence_rule.dates(end_date: Time.current.end_of_day)
    end

    def recurrence_rule
      @recurrence_rule ||= task.recurrence_rule
    end
  end
end
