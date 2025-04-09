class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :movie
  validates :score , inclusion: 1..10

  has_many :comments
  before_action :authenticate_user!, only: [:new, :create]

end
