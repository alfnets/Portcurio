class FileType < ApplicationRecord
  belongs_to :file_category
  # has_many :micropost
end
