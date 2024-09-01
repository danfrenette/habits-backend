class Task < ApplicationRecord
  belongs_to :user
  belongs_to :response, optional: true
  has_many :assignments, class_name: "TaskAssignment", dependent: :destroy
  has_one :recurrence_rule

  validates :slug, uniqueness: {scope: :user_id}
  validates :title, presence: true
  validates :title, uniqueness: {scope: :user_id}

  default_scope -> { kept }

  scope :recurring_indefinitely, -> { where(recurring: true, end_recurrence_at: nil) }
  scope :recurring_until_future_date, -> { where(recurring: true).where("end_recurrence_at > ?", Time.current) }
  scope :actively_recurring, -> { active.recurring_indefinitely.or(recurring_until_future_date) }

  enum status: {active: "active", completed: "completed"}

  alias_attribute :recurrence_ends_at, :end_recurrence_at
end
