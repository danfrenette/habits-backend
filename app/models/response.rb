class Response < ApplicationRecord
  belongs_to :habit

  validates :description, presence: true
end
