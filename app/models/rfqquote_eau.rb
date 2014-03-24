class RfqquoteEau < ActiveRecord::Base
	include SessionsHelper
	
	belongs_to :rfqquote
	belongs_to :eau

	validates(:tooling,  allow_nil: true, :numericality => {:greater_than => 0, :on => :update} )
	validates(:nre,  allow_nil: true, :numericality => {:greater_than => 0, :on => :update} )

	validates(:unit_price, presence:true, allow_nil: false, 
		:numericality => {:greater_than => 0}, on: :update, if: :valid_unit_price )	

	def valid_unit_price
		if (self.no_quote || current_user.isTLX) then false
		else true
		end
	end

	def eau_qty
		return (rfqquote.rfqpart.qty * eau.value).round(2)
	end
end
