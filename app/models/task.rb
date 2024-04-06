class Task < ApplicationRecord
  belongs_to :user
  belongs_to :response, optional: true
  has_one :recurrence_rule

  validates :title, presence: true
  validates :title, uniqueness: {scope: :response_id}, if: :response_id?

  scope :recurring_indefinitely, -> { where(end_recurrence_at: nil) }
  scope :recurring_until_future_date, -> { where("end_recurrence_at > ?", Time.current) }
  scope :still_recurring, -> { recurring_indefinitely.or(recurring_until_future_date) }

  enum status: {active: "active", completed: "completed"}
end
