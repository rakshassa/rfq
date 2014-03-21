class Search < ActiveRecord::Base
	include SessionsHelper

  validate :check_dates

  def check_dates
      if (!check_date(self.date_built)) then return false end
      if (!check_date(self.date_quoted)) then return false end
      return true
  end

  def check_date(date_value)
      if date_value.blank? then true
      else
        dates = parse_date_range(date_value)
        if (dates.nil?) then        
          self.errors[:base] << ("Invaild date format.")
        end
        return dates.nil?
      end
  end

  def parse_date_range(date_range_string)
    pieces = date_range_string.split('-')
    if (pieces.size != 2) then 
      logger.error("invalid date: " + date_range_string)
      return nil 
    end

    start_date = Date.parse(pieces[0])
    end_date = Date.parse(pieces[1])

    if (start_date == nil) then 
      logger.error("invalid date: " + pieces[0])
      return nil 
    end
    if (end_date == nil) then 
      logger.error("invalid date: " + pieces[1])
      return nil 
    end

    return pieces

  end

	def search_results(page)
		@rfqforms = GetForms(page)
	end



    def GetForms(page)

      forms = Rfqform.order("id DESC");
      forms = forms.where('rfqforms.id=?', rfq) if rfq.present?
      forms = forms.where('rfqforms.built=?', built.to_bool) if built.present?
      forms = forms.where(rfqforms: { program: program}) if program.present?

      build_dates = nil
      build_dates = parse_date_range(date_built) if date_built.present?
      forms = forms.where('rfqforms.built=? AND rfqforms.date >= ? AND rfqforms.date <= ?', true, Date.parse(build_dates[0]), Date.parse(build_dates[1])) if !build_dates.nil?

      forms = forms.joins(rfqquotes: :vendor) if (vendor.present? || quote_number.present? || date_quoted.present? || !current_user.isTLX)
      forms = forms.where('rfqquotes.vendor_id=?', current_user.vendor_id) if !current_user.isTLX
      forms = forms.where('rfqquotes.quote_number like ?', "%#{quote_number}%") if quote_number.present?      

      quote_dates = nil
      quote_dates = parse_date_range(date_quoted) if date_quoted.present?
      forms = forms.where('rfqquotes.submitted_to_tlx = ? AND rfqquotes.quote_date >= ? AND rfqquotes.quote_date <= ?', true, Date.parse(quote_dates[0]), Date.parse(quote_dates[1])) if !quote_dates.nil?

      forms = forms.where('vendors.name like ?', "%#{vendor}%") if vendor.present?
      forms = forms.uniq
      forms = forms.paginate(page: page, :order => "id DESC", :per_page => 10 )
      forms
    end


    def GetQuotes(rfqforms)
      quotes = {}
      rfqforms.each do |form|
        if (form.built) then
          quotes[form.id] = []
          if (current_user.isTLX) then
            quotes[form.id] << Rfqquote.where("rfqform_id=?", form.id).order("rfqquote_display_id ASC")
          else
            quotes[form.id] << Rfqquote.where("rfqform_id=? and vendor_id=?", form.id,  current_user.vendor_id).order("rfqquote_display_id ASC")
          end
        end
      end

      return quotes      
    end
end
