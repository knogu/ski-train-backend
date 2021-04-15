class Transfer < ApplicationRecord
  validates :station_id, uniqueness: { scope: [:train_line_1_id, :train_line_2_id] }
end
