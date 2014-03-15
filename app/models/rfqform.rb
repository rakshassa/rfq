class Rfqform < ActiveRecord::Base
	has_many :eaus, dependent: :destroy
	accepts_nested_attributes_for :eaus, allow_destroy: true,
			reject_if: :all_blank

	has_many :rfqparts, dependent: :destroy	
	accepts_nested_attributes_for :rfqparts, allow_destroy: true,
			reject_if: :all_blank		
end
