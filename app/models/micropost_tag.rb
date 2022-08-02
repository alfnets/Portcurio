class MicropostTag < ApplicationRecord
  belongs_to :micropost
  belongs_to :tag
  belongs_to :user
end
