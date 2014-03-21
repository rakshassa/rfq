class SearchesController < ApplicationController
	def new
		if (!current_user.isTLX) then redirect_to rfqforms_path and return end
			
		@search = Search.new
	end

	def create		
		if (!current_user.isTLX) then redirect_to rfqforms_path and return end



		@search = Search.new(search_params)		

	    if @search.save	      	      
	      redirect_to @search
	    else	      
	      render 'new'
	    end		
	end

	def show
		if (!current_user.isTLX) then redirect_to rfqforms_path and return end

		@search = Search.find(params[:id])
		@rfqforms = @search.search_results(params[:page])		
    	@quotes = @search.GetQuotes(@rfqforms)    	
	end

  private

    def search_params
      params.require(:search).permit(:built, :vendor, :program, :rfq, 
      	:quote_number, :date_built, :date_quoted, :part)
    end  	
end
