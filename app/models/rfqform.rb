class Rfqform < ActiveRecord::Base

	default_scope { order(:id) }

	has_many :eaus, dependent: :destroy
	accepts_nested_attributes_for :eaus, allow_destroy: true,
			reject_if: :all_blank

	has_many :rfqparts, dependent: :destroy	
	accepts_nested_attributes_for :rfqparts, allow_destroy: true,
			reject_if: :all_blank	

	validates(:req_by,  presence: true, allow_nil: true )
	validates(:engineer,  presence: true, allow_nil: true )
end
