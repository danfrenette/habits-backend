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

      dates.each do |date|
        TaskCompletion.find_or_create_by!(task: task, due_at: date)
      end
    end

    private

    attr_reader :task

    def task_is_not_actively_recurring?
      task.completed? || !task.recurring || task.recurrence_ends_at.present? && task.recurrence_ends_at < Time.current
    end

    def dates
      @dates ||= RRule.parse(recurrence_rule.rrule).between(Time.current, Time.current.end_of_week)
    end

    def recurrence_rule
      task.recurrence_rule
    end
  end
end
