class Tag < ApplicationRecord
  has_many :micropost_tags, dependent: :destroy
  has_many :microposts, through: :micropost_tags, dependent: :destroy
  has_many :micropost_tags
  has_many :microposts, through: :micropost_tags
end
