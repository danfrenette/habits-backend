module Queries
  class TaskSearch
    module Scopes
      def for_user(user_id)
        return self if user_id.blank?

        where(user_id: user_id)
      end
    end

    def self.call(filters)
      Task
        .extending(Scopes)
        .for_user(filters[:user_id])
    end
  end
end
