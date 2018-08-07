class Generation < ApplicationRecord
  belongs_to :female, class_name: :User, foreign_key: :child_id
  belongs_to :male, class_name: :User, foreign_key: :parent_id

  scope :male_child, -> {where(child_gender: '0')}
  scope :famale_child, -> {where(child_gender: '1')}
  scope :male_parent, -> {where(parent_gender: '0')}
  scope :famale_parent, -> {where(parent_gender: '1')}

  belongs_to :child, class_name: :User, foreign_key: :child_id
  belongs_to :daughter, class_name: :User, foreign_key: :child_id

  belongs_to :parent, class_name: :User, foreign_key: :parent_id
  belongs_to :mother, class_name: :User, foreign_key: :parent_id
end
