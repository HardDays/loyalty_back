class Card < ApplicationRecord
    validates :number, length: {minimum: 1, maximum: 64}
    validates :points, inclusion: 0..10000000000

    belongs_to :company
    belongs_to :operator

end
