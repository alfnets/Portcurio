class FileCategory < ApplicationRecord
  has_many :file_types, dependent: :destroy
end
