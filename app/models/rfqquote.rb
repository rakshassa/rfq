class Rfqquote < ActiveRecord::Base
	has_many :rfqquote_eaus, dependent: :destroy
	accepts_nested_attributes_for :rfqquote_eaus, allow_destroy: false,
			reject_if: :all_blank

	validates(:quote_number,  presence: true, allow_nil: false, on: :update )
	validates(:quote_date,    presence: true, allow_nil: false, on: :update )
	validates(:submitted_by,  presence: true, allow_nil: false, on: :update )
	validates(:valid_till,    presence: true, allow_nil: false, on: :update )
end
     