class Board < ApplicationRecord
  # Relations
  belongs_to :playerx, class_name: 'Player'
  belongs_to :playero, class_name: 'Player', optional: true

  enum winner: { pending: 0, x: 1, o: 2, draw: 3 }
end
