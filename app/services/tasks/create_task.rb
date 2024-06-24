module Tasks
  class CreateTask
    include ActiveModel::Model
    attr_accessor :clerk_id, :title, :recurring, :rrule

    def self.call(params)
      new(params).call
    end

    def call
      create_task.tap { |task| create_recurrence_rule(task) if recurring }
    end

    private

    def create_task
      Task.create(
        title: title,
        user: user,
        recurring: recurring,
        status: :active,
        slug: slug
      )
    end

    def user
      @_user ||= User.find_in_clerk(clerk_id)
    end

    def create_recurrence_rule(task)
      RecurrenceRule.create(task: task, rrule: rrule)
    end

    def slug
      slug = title.parameterize

      if Task.exists?(slug: slug)
        "#{slug}-#{SecureRandom.hex(2)}"
      else
        slug
      end
    end
  end
end
