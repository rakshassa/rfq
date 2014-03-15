class Rfqpart < ActiveRecord::Base
	belongs_to :rfqform


    serialize :rfqpartvendors			
end
