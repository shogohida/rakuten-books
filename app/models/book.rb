class Book < ApplicationRecord
  belongs_to :publisher
  belongs_to :author
  validates :title, presence: true
end
