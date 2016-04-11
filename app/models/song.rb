class Song < ActiveRecord::Base
  
  has_many :users, through: :votes
  has_many :votes

  validates :title, presence: true, length: {maximum:40}
  validates :artist, presence: true, length: {maximum: 30}

end