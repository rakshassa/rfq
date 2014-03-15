class Rfqpart < ActiveRecord::Base
	belongs_to :rfqform
	default_scope { order(:id) }

	has_attached_file :drawing

	

	validates_attachment :drawing, 
  		:content_type => { :content_type => /\Aimage\/.*\Z/ },
  		:size => { :in => 0..500.kilobytes }
		

    serialize :rfqpartvendors			
end
