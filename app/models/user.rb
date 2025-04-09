class User < ApplicationRecord
  has_many :ratings
  has_many :comments
  before_action :authenticate_user!, only: [:new, :create]
  
end
