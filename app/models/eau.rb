class Eau < ActiveRecord::Base
	belongs_to :rfqform

	validates :value, :numericality => {:only_integer => true}
	
end
