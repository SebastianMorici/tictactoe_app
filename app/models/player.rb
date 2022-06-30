class Player < ApplicationRecord
  # Validations
  validates :name, presence: true, uniqueness: true

  # Relations
  has_many :playerx_boards, class_name: 'Board',
                            foreign_key: 'playerx_id'
  has_many :playero_boards, class_name: 'Board',
                            foreign_key: 'playero_id'
end
