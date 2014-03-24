class Rfqpart < ActiveRecord::Base
	belongs_to :rfqform
	belongs_to :part, :foreign_key => "part_number"
	has_one :rfqquote

	default_scope { order(:id) }
	
	mount_uploader :drawing, DrawingUploader

	validates(:part_number,  presence: true, allow_nil: false )
	validates(:revision,  presence: true, allow_nil: false )
	validates(:qty,  :numericality => {:only_integer => false} )
	validates(:units,  presence: true, allow_nil: false )
	validate :check_vendors
	validates(:drawing,  presence: true, allow_nil: false )

	def check_vendors
	    if self.rfqpartvendors.blank? || self.rfqpartvendors.reject(&:blank?).blank?
	    	self.errors[:base] << ("Must have at least one Vendor for each part.")
	    end
	end

	def vendor_name_list
		return self.rfqpartvendors.reject(&:blank?).map { |f| Vendor.find(f).name }.join("\n")
	end

	#validates_attachment :drawing, 
  	#	:content_type => { :content_type => /\Aimage\/.*\Z/ },
  	#	:size => { :in => 0..500.kilobytes }
		

    serialize :rfqpartvendors			
end
