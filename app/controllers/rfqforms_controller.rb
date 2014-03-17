class RfqformsController < ApplicationController

  def index
    @rfqforms = Rfqform.paginate(page: params[:page])
  end	

  def show
  	@rfqform = Rfqform.find(params[:id])

    respond_to do |format|
      format.pdf do
        #uncomment to force download instead of immediate view.
        prawnto filename: "Rfq #{@rfqform.id.to_s.rjust(4, '0')}.pdf", :inline => false
      end
      format.html do
        redirect_to rfqforms_path
      end
    end    
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
    @rfqform.date = DateTime.now.to_date

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
    @rfqform.date = DateTime.now.to_date
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

  def build
    @rfqform = Rfqform.find(params[:id])
    if (@rfqform.built) then
      flash[:error] = "This form has already been built."
      redirect_to rfqforms_path and return
    end
    
    anyfail = false;
    anysuccess = false;
    if (@rfqform.rfqparts.any?) then
      @rfqform.rfqparts.each do |part| 
        if (part.rfqpartvendors.any?) then   
          part.rfqpartvendors.reject(&:blank?).each do |vendor|
            quote = Rfqquote.new(
              rfqform_id: @rfqform.id,
              vendor_id: vendor.to_i,
              part_id: part.id)

            result = nil
            begin
              result = quote.save
            rescue Exception
              flash[:error] = "This form has already been built."
            end
            if (result)  then              
              anysuccess = true;
            else 
              anyfail = true;
            end            
          end         
        end
      end    
    end

    if (anysuccess)  then
      @rfqform.built = true;
      @rfqform.update_attributes(built: true)
      
      flash[:success] = "Built!"
      redirect_to rfqforms_path
    else 
      if !anyfail then
        flash[:error] += "There are no vendors in this RFQ."
      end
      redirect_to rfqforms_path
    end  

  end


  private

    def rfqforms_params
      params.require(:rfqform).permit(:date, :release_type, :launch_date,
        :ppap, :req_by, :engineer, :info, :program,

        eaus_attributes: [:id, :value, :_destroy],
        rfqparts_attributes: [:id, :part_number, :revision, 
          :qty, :units, :drawing, :_destroy,
          rfqpartvendors: []])
    end  
end