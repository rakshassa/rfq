class Rfqquote < ActiveRecord::Base
	include SessionsHelper
	
	belongs_to :rfqform
	belongs_to :vendor
	

	has_many :rfqquote_eaus, dependent: :destroy
	accepts_nested_attributes_for :rfqquote_eaus, allow_destroy: false,
			reject_if: :all_blank

	validates(:quote_number,  presence: true, allow_nil: false, on: :update, if: :valid_user )
	validates(:quote_date,    presence: true, allow_nil: false, on: :update, if: :valid_user )
	validates(:submitted_by,  presence: true, allow_nil: false, on: :update, if: :valid_user )
	validates(:valid_till,    presence: true, allow_nil: false, on: :update, if: :valid_user )

	def valid_user
		if (current_user.isTLX) then false
		else true
		end
	end
end
     