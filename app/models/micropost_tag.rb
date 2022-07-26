class MicropostTag < ApplicationRecord
  belongs_to :micropost
  belongs_to :tag
end
