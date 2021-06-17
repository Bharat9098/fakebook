class User < ApplicationRecord
  
  # associations
  has_many :posts
  has_many :comments
  has_many :likes, dependent: :destroy
  has_many :notifications, dependent: :destroy

  # friendship associations

  has_many :friend_sent, class_name: 'Friendship', foreign_key: 'sent_by_id', inverse_of: 'sent_by', dependent: :destroy
  has_many :friend_request, class_name: 'Friendship', foreign_key: 'sent_to_id', inverse_of: 'sent_to', dependent: :destroy
  has_many :friends, -> { merge(Friendship.friends) }, through: :friend_sent, source: :sent_to
  has_many :pending_requests, -> { merge(Friendship.not_friends) }, through: :friend_sent, source: :sent_to
  has_many :received_requests, -> { merge(Friendship.not_friends) }, through: :friend_request, source: :sent_by


  #image uploader
  mount_uploader :image, ImageUploader

  # devise
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # validation       
  validate :picture_size

  def full_name
    "#{fname} #{lname}"
  end

  def friend_and_own_posts
    my_friends = friends
    our_posts = []
    my_friends.each do |f|
      f.posts.each do |p|
        our_posts << p
      end
    end

    posts.each do |p|
      our_posts << p
    end
    our_posts
  end

    
  private
  # Validates the size of an uploaded picture.
  def picture_size
    errors.add(:image, 'should be less than 1MB') if image.size > 1.megabytes
  end       
end
