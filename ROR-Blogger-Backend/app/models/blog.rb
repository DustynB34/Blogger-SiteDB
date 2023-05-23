class Blog < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates :views, presence: true, numericality: { only_integer: true, no_strings: true }
  validates :likes, presence: true, numericality: { only_integer: true, no_strings: true }
  validates :dislikes, presence: true, numericality: { only_integer: true, no_strings: true }
  validates :age_rating, presence: true, numericality: { only_integer: true, no_strings: true }

  belongs_to :user
  belongs_to :topic
  has_many :comments
end
