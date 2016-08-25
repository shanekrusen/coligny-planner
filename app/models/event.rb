class Event < ApplicationRecord
  belongs_to :user
  validates :name, :start_time, :end_time, :day, :month, :year, :metonic, :user_id, :date, :duration, presence: true
  validates :duration, numericality: { greater_than_or_equal_to: 1 }
end
