module Queries
  class TaskSearch
    module Scopes
      def for_user(user_clerk_id)
        return self if user_clerk_id.blank?

        where(user: User.find_in_clerk(user_clerk_id))
      end
    end

    def self.call(filters)
      Task
        .extending(Scopes)
        .for_user(filters[:user_clerk_id])
    end
  end
end
