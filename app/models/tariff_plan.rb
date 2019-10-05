class TariffPlan < ApplicationRecord
    validates :name, length: {minimum: 1, maximum: 128}
    validates :description, length: {minimum: 1, maximum: 512}
    validates :price, inclusion: 0..100000000

    enum tariff_type: [:demo, :paid]
end
