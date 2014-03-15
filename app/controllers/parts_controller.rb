class PartsController < ApplicationController

  def description
    @part = Part.find(params[:part_id])  
    @element = params[:element];

    
    respond_to do |format|      
      format.js
    end  
  end
end
