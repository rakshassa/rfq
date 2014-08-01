class SearchesController < ApplicationController
	def new
		if (!validate_user()) then redirect_to APP_CONFIG['login_redirect'] and return end
		if (!current_user.isTLX) then redirect_to rfqforms_path and return end
			
		@search = Search.new
	end

	def create	
		if (!validate_user()) then redirect_to APP_CONFIG['login_redirect'] and return end	
		if (!current_user.isTLX) then redirect_to rfqforms_path and return end

		@search = Search.new(search_params)		

	    if @search.save	      	      
	      redirect_to @search
	    else	      
	      render 'new'
	    end		
	end

	def show
		if (!validate_user()) then redirect_to APP_CONFIG['login_redirect'] and return end
		if (!current_user.isTLX) then redirect_to rfqforms_path and return end

		@search = Search.find(params[:id])
		@rfqforms = @search.forms.order('id DESC').paginate(page: params[:page], :per_page => 10 )		
    	@quotes = @search.GetQuotes(@rfqforms)    	
	end

  private

    def search_params
      params.require(:search).permit(:built, :vendor, :program, :rfq, 
      	:quote_number, :date_built, :date_quoted, :part)
    end  	
end
