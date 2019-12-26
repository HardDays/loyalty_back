class Card < ApplicationRecord
    validates :number, length: {minimum: 1, maximum: 64}#, uniqueness: true
    validates :points, inclusion: 0..10000000000

    validates_uniqueness_of :number, scope: :company_id

    belongs_to :company
    #belongs_to :operator
end
