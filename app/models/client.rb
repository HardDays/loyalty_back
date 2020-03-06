class Client < ApplicationRecord

	belongs_to :company
	belongs_to :user
	belongs_to :loyalty_program
	belongs_to :operator, optional: true

	has_many :orders, dependent: :nullify
	has_many :client_points, dependent: :nullify

	validates :user, uniqueness: { scope: [:company] }
	validates :card_number, length: {minimum: 0, maximum: 64}, allow_nil: true

	def valid_points
		return client_points.where('activation_date <= ?', DateTime.now).
			where('burning_date > ?', DateTime.now).
			where('current_points > 0').
			order(created_at: :asc)
	end

	def as_json(options = {})
		attrs = super.except('user_id').except('id')

		#attrs[:user_type] = :client
		attrs[:card_number] = card_number
		attrs[:company] = company

		if options
			if options[:points]
				attrs[:points] = valid_points.sum{|p| p.current_points}
			end
			if options[:loyalty_program]
				attrs[:loyalty_program] = loyalty_program.as_json(loyalty_levels: true)
			end
		end
	
		return attrs
	end
end
