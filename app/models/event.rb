class Event < ApplicationRecord
  belongs_to :user
  validates :name, :start_time, :end_time, :day, :month, :year, :metonic, :user_id, presence: true
end
