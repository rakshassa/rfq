class Eau < ActiveRecord::Base
	belongs_to :rfqform
	has_many :rfqquoteEaus

	validates :value, :numericality => {:only_integer => true, :greater_than => 0}
	
end
