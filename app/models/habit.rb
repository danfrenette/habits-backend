class Habit < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, uniqueness: {scope: :user_id}
end
