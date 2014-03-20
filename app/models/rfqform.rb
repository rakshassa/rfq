class Rfqform < ActiveRecord::Base

	#default_scope { order(:id) }

	has_many :eaus, dependent: :destroy
	accepts_nested_attributes_for :eaus, allow_destroy: true,
			reject_if: :all_blank

	has_many :rfqparts, dependent: :destroy	
	accepts_nested_attributes_for :rfqparts, allow_destroy: true,
			reject_if: :all_blank	

	has_many :rfqquotes, dependent: :destroy

	validates(:req_by,  presence: true, allow_nil: false )
	validates(:engineer,  presence: true, allow_nil: false )
	validates(:program,  presence: true, allow_nil: false )
	validate :check_eaus

	def check_eaus
	    if self.eaus.size < 1 || self.eaus.all?{|eau| eau.marked_for_destruction? }
	      self.errors[:base] << ("Must have at least one EAU.")
	    end
    end		

end
