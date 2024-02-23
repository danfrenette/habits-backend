class Task < ApplicationRecord
  belongs_to :user
  belongs_to :response, optional: true

  validates :title, presence: true
  validates :title, uniqueness: {scope: :response_id}, if: :response_id?

  enum status: {pending: "pending", completed: "completed"}
end
