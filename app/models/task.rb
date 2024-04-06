class Task < ApplicationRecord
  belongs_to :user
  belongs_to :response, optional: true
  has_one :recurrence_rule

  validates :title, presence: true
  validates :title, uniqueness: {scope: :response_id}, if: :response_id?

  enum status: {pending: "pending", completed: "completed"}
end
