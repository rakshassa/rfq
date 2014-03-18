class RfqquotesController < ApplicationController

  def show
  end

  def edit
  	@rfqquote = Rfqquote.find(params[:id])
  end

  def update
  end

end
