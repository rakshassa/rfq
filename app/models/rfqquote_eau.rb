class RfqquoteEau < ActiveRecord::Base
	include SessionsHelper
	
	belongs_to :rfqquote
	belongs_to :eau

	validates(:tooling,  allow_nil: true, :numericality => {:only_integer => true, :greater_than => -1, :on => :update} )
	validates(:nre,  allow_nil: true, :numericality => {:only_integer => true, :greater_than => -1, :on => :update} )

	validates(:unit_price, presence:true, allow_nil: false, 
		:numericality => {:only_integer => false, :greater_than => -1}, on: :update, if: :valid_unit_price )	

	def valid_unit_price
		if (self.no_quote || current_user.isTLX) then false
		else true
		end
	end

	def eau_qty
		return (rfqquote.rfqpart.qty * eau.value).floor
	end
end
