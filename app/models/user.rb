class User < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :clerk_id, presence: true, uniqueness: true

  has_many :habits
  has_many :tasks
  has_many :task_assignments, through: :tasks, source: :assignments

  def self.find_in_clerk(clerk_id)
    find_by(clerk_id: clerk_id)
  end
end
