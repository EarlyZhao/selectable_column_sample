class Couple < ApplicationRecord
  belongs_to :wife, class_name: :User, foreign_key: :wife_id
  belongs_to :male, class_name: :User, foreign_key: :husband_id
end
