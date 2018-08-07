class Organization < ApplicationRecord
  belongs_to :user, class_name: :User, foreign_key: :owner_id
  has_many :products
end
