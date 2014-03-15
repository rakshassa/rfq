class Rfqpart < ActiveRecord::Base
	belongs_to :rfqform

	has_many :rfqpartvendors, dependent: :destroy
	accepts_nested_attributes_for :rfqpartvendors, allow_destroy: true,
			reject_if: :all_blank
end
