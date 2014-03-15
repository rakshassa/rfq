class RfqformsController < ApplicationController

  def index
    @rfqforms = Rfqform.paginate(page: params[:page])
  end	

  def show
  	@rfqform = Rfqform.find(params[:id])
  end

  def destroy
    @rfqform = Rfqform.find(params[:id])    
    @rfqform.destroy

    
    respond_to do |format|      
      format.js
    end    
  end

  def create
    @rfqform = Rfqform.new(rfqforms_params)

    if @rfqform.save
      flash[:success] = "Created!"
      
      redirect_to rfqforms_path
    else
      render 'new'
    end
  end

  def new
  	@rfqform = Rfqform.new 
    @address = @rfqform.eaus.build 
    @contact = @rfqform.rfqparts.build
    rfqform.date = DateTime.now.to_date
  end  

  def edit
    @rfqform = Rfqform.find(params[:id])
  end  

  def update
    @rfqform = Rfqform.find(params[:id])
    if @rfqform.update_attributes(rfqforms_params)
      flash[:success] = "Updated"
      redirect_to rfqforms_path
    else
      render 'edit'
    end
  end    

  private

    def rfqforms_params
      params.require(:rfqform).permit(:date, :release_type, :launch_date,
        :ppap, :req_by, :engineer, :info, 

        eaus_attributes: [:id, :value, :_destroy],
        rfqparts_attributes: [:id, :part_number, :revision, 
          :qty, :units, :_destroy,
          rfqpartvendors_attributes: [:vendor_id, :_destroy]])
    end  
end