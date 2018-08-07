class User < ApplicationRecord
  has_many :organizations, class_name: :Organization, foreign_key: :owner_id
  has_one :introduction


  has_one :generation_childs,-> { where(child_gender: '0') }, class_name: :Generation, foreign_key: :parent_id
  has_one :generation_parent, class_name: :Generation, foreign_key: :child_id

  has_many :male_generation,-> { where(child_gender: '0') }, class_name: :Generation, foreign_key: :parent_id
  has_many :female_generation,-> { where(child_gender: '1') }, class_name: :Generation, foreign_key: :parent_id

  has_one :male_parent,-> { where(parent_gender: '0') }, class_name: :Generation, foreign_key: :child_id
  has_one :female_parent,-> { where(parent_gender: '1') }, class_name: :Generation, foreign_key: :child_id

  has_one :father, through: :male_parent, source: :parent
  has_one :mother, through: :female_parent, source: :parent

  has_many :sons, through: :male_generation, source: :child
  has_many :daughters, through: :female_generation, source: :daughter

  has_one :couple_female, class_name: :Couple, foreign_key: :wife_id
  has_one :couple_male, class_name: :Couple, foreign_key: :husband_id
  has_one :wife, through: :couple_male, source: :wife
  has_one :husband, through: :couple_female, source: :male

end
