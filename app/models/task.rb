class Task < ApplicationRecord
  belongs_to :user
  belongs_to :response, optional: true
  has_many :completions, class_name: "TaskCompletion", dependent: :destroy
  has_one :recurrence_rule

  validates :title, presence: true
  validates :title, uniqueness: {scope: :response_id}, if: :response_id?

  scope :recurring_indefinitely, -> { where(recurring: true, end_recurrence_at: nil) }
  scope :recurring_until_future_date, -> { where(recurring: true).where("end_recurrence_at > ?", Time.current) }
  scope :actively_recurring, -> { active.recurring_indefinitely.or(recurring_until_future_date) }

  enum status: {active: "active", completed: "completed"}

  alias_attribute :recurrence_ends_at, :end_recurrence_at
end
