class Comment < ApplicationRecord
  validates :content, presence: true
  validates :likes, presence: true, numericality: { only_integer: true, no_strings: true }
  validates :dislikes, presence: true, numericality: { only_integer: true, no_strings: true }

  belongs_to :blogs
end
