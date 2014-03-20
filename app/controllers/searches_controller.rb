class SearchesController < ApplicationController
	def new
		@search = Search.new
	end

	def create		
		@search = Search.new(search_params)		

	    if @search.save	      	      
	      redirect_to @search
	    else	      
	      render 'new'
	    end		
	end

	def show
		@search = Search.find(params[:id])
		@rfqforms = @search.search_results(params[:page])		
    	@quotes = @search.GetQuotes(@rfqforms)    	
	end

  private

    def search_params
      params.require(:search).permit(:built, :vendor, :program, :rfq, :quote_number)
    end  	
end
