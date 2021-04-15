class TrainLine < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
