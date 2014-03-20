class Search < ActiveRecord::Base
	include SessionsHelper

	def search_results(page)
		@rfqforms = GetForms(page)
	end



    def GetForms(page)

      forms = Rfqform.order("id DESC");
      forms = forms.where('rfqforms.id=?', rfq) if rfq.present?
      forms = forms.where('rfqforms.built=?', built.to_bool) if built.present?
      forms = forms.joins(rfqquotes: :vendor) if (vendor.present? || quote_number.present?)
      forms = forms.where('rfqquotes.vendor_id=?', current_user.vendor_id) if !current_user.isTLX
      forms = forms.where('rfqquotes.quote_number like ?', "%#{quote_number}%") if quote_number.present?
      forms = forms.where(rfqforms: { program: program}) if program.present?
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
            quotes[form.id] << Rfqquote.where("rfqform_id=?", form.id)
          else
            quotes[form.id] << Rfqquote.where("rfqform_id=? and vendor_id=?", form.id,  current_user.vendor_id)
          end
        end
      end

      return quotes      
    end
end
