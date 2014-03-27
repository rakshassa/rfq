
class Rfqform < ActiveRecord::Base	
	include SessionsHelper
	
	scope :limit_to_vendor, ->(vendor_id_param) { joins(:rfqquotes).where(:rfqquotes => { :vendor_id => vendor_id_param } ).uniq }

	has_many :eaus, dependent: :destroy
	accepts_nested_attributes_for :eaus, allow_destroy: true,
			reject_if: :all_blank

	has_many :rfqparts, dependent: :destroy	
	accepts_nested_attributes_for :rfqparts, allow_destroy: true,
			reject_if: :all_blank	

	has_many :rfqquotes, dependent: :destroy

	belongs_to :req_by_employee, foreign_key: :req_by, class_name: "Employee"
	belongs_to :engineer_employee, foreign_key: :engineer, class_name: "Employee"


	validates(:req_by,  presence: true, allow_nil: false )
	validates(:engineer,  presence: true, allow_nil: false )
	validates(:program,  presence: true, allow_nil: false )
	validate :check_eaus

	def check_eaus
		if Rails.env.test? then
			return true
		end

	    if self.eaus.size < 1 || self.eaus.all?{|eau| eau.marked_for_destruction? }
	      self.errors[:base] << ("Must have at least one EAU.")
	    end
    end	

    def create_search
    	newSearch = Search.create!(rfq: id)
    	return newSearch.id
    end

    def printable_id
    	self.id.to_s.rjust(4, '0')
    end

    def program_name
    	if (self.program.blank?) then return ""
    	else return Part.find(self.program).name end
    end

    def auth_quotes	  
      if (current_user.isTLX) then        
        return self.rfqquotes.sorted     
      end

      return self.rfqquotes.limit_to_vendor(current_user.vendor_id).sorted
    end

    def build() 
    	results = []
	    anysuccess = false;
	    if (self.rfqparts.any?) then
	      counter = 1 
	      self.rfqparts.each do |part| 
	        if (part.rfqpartvendors.any?) then            
	          part.rfqpartvendors.reject(&:blank?).each do |vendor|
	            quote = Rfqquote.new(
	              rfqquote_display_id: counter,
	              rfqform_id: self.id,
	              vendor_id: vendor.to_i,
	              part_id: part.id)
	            counter = counter + 1
	            result = nil
	            begin
	              result = quote.save
	            rescue Exception
	              (flash[:error] ||= []) << "This form has already been built."
	            end
	            if (result)  then              
	              anysuccess = true;
	              self.eaus.each do |eau|
	              	quote_eau = quote.rfqquote_eaus.build(eau_id: eau.id)
	              	quote_eau.save
	              end
	              results << quote
	            end    
	          end         
	        end
	      end    
	    end

	    if (anysuccess)  then
	      self.built = true;
	      self.update_attributes(built: true, date: DateTime.now.to_date)
	    end

	    return results
    end

end
