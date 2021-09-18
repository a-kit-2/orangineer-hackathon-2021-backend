class Event < ApplicationRecord
  belongs_to :user
  has_many :joinnings, dependent: :destroy
  has_many :users, through: :joinnings
  has_many :comments, dependent: :destroy

  
end
