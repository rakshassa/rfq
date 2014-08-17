class Search < ActiveRecord::Base


  validate :check_dates

  def check_dates
      if (!check_date(self.date_built)) then return false end
      if (!check_date(self.date_quoted)) then return false end
      return true
  end

  def check_date(date_value)
      if date_value.blank? then return true end
      
      dates = parse_date_range(date_value)
      if (dates.nil?) then        
        self.errors[:base] << ("Invaild date format.")
      end
      return (!(dates.nil?))
      
  end

  def parse_date_range(date_range_string)
    pieces = date_range_string.split('-')
    if (pieces.size != 2) then 
      logger.error("invalid date: " + date_range_string)
      return nil 
    end

    start_date = Date.parse(pieces[0]) rescue nil
    end_date = Date.parse(pieces[1]) rescue nil

    if (start_date == nil || end_date == nil) then return nil end
      
    return pieces

  end

  def forms(user)

    forms = Rfqform.order("id DESC");
    forms = forms.where('rfqforms.id=?', rfq) if rfq.present?
    forms = forms.where('rfqforms.built=?', built.to_bool) if built.present?
    forms = forms.where(rfqforms: { program: program}) if program.present?

    build_dates = nil
    build_dates = parse_date_range(date_built) if date_built.present?
    forms = forms.where('rfqforms.built=? AND rfqforms.date >= ? AND rfqforms.date <= ?', true, Date.parse(build_dates[0]), Date.parse(build_dates[1])) if !build_dates.nil?

    forms = forms.joins(rfqquotes: :vendor) if (vendor.present? || quote_number.present? || date_quoted.present? || !user.isTLX)
    forms = forms.where('rfqquotes.vendor_id=?', user.vendor_id) if !user.isTLX
    forms = forms.where('rfqquotes.quote_number like ?', "%#{quote_number}%") if quote_number.present?      

    quote_dates = nil
    quote_dates = parse_date_range(date_quoted) if date_quoted.present?
    forms = forms.where('rfqquotes.submitted_to_tlx = ? AND rfqquotes.quote_date >= ? AND rfqquotes.quote_date <= ?', true, Date.parse(quote_dates[0]), Date.parse(quote_dates[1])) if !quote_dates.nil?

    forms = forms.where('vendors.name like ?', "%#{vendor}%") if vendor.present?
    forms = forms.uniq      
    return forms
  end


  def GetQuotes(rfqforms, user)
    quotes = {}
    rfqforms.each do |form|
      if (form.built) then
        quotes[form.id] = []
        if (user.isTLX) then
          quotes[form.id] << Rfqquote.where("rfqform_id=?", form.id).order("rfqquote_display_id ASC")
        else
          quotes[form.id] << Rfqquote.where("rfqform_id=? and vendor_id=?", form.id,  user.vendor_id).order("rfqquote_display_id ASC")
        end
      end
    end

    return quotes      
  end
end
