class User < ActiveRecord::Base

  has_many :songs, through: :votes
  has_many :votes

  validates :name, presence:true, length: {minimum: 4}
  validates :email, presence: true, length: {minimum: 4}
  validates :password, presence: true, length: {minimum: 4}
  
  def add_song(song_name, artist_name)
    Song.new(title: song_name, artist: artist_name, user_id: self.id)
  end

end