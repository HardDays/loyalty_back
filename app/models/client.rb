class Client < ApplicationRecord

  belongs_to :company
  belongs_to :user
  belongs_to :loyalty_program, optional: true

  has_many :orders, dependent: :nullify
  has_many :client_points, dependent: :nullify

  def valid_points
    puts json: client_points
    return client_points.where('activation_date <= ?', DateTime.now).
                         where('burning_date > ?', DateTime.now).
                         where('points > 0').order(created_at: :asc)
  end

end
