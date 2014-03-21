class Rfqpart < ActiveRecord::Base
	belongs_to :rfqform
	default_scope { order(:id) }

	has_attached_file :drawing

	validates(:part_number,  presence: true, allow_nil: false )
	validates(:revision,  presence: true, allow_nil: false )
	validates(:qty,  :numericality => {:only_integer => false} )
	validates(:units,  presence: true, allow_nil: false )
	validate :check_vendors
	#validates(:drawing,  presence: true, allow_nil: false )

	def check_vendors
	    if self.rfqpartvendors.blank? || self.rfqpartvendors.reject(&:blank?).blank?
	    	self.errors[:base] << ("Must have at least one Vendor for each part.")
	    end
	end

	#validates_attachment :drawing, 
  	#	:content_type => { :content_type => /\Aimage\/.*\Z/ },
  	#	:size => { :in => 0..500.kilobytes }
		

    serialize :rfqpartvendors			
end
