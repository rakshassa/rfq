class RfqformsController < ApplicationController

  def index
    @rfqforms = GetForms(params[:page])
    @quotes = GetQuotes(@rfqforms)
  end	

  def show
    if (!current_user.isTLX) then redirect_to rfqforms_path and return end

  	@rfqform = Rfqform.find(params[:id])

    respond_to do |format|
      format.pdf do        
        prawnto filename: "Rfq #{@rfqform.printable_id}.pdf", :inline => false
      end
      format.html
      
    end    
  end

  def destroy
    if (!current_user.isTLX) then redirect_to rfqforms_path and return end

    @rfqform = Rfqform.find(params[:id])  
    if (@rfqform.built) then
      flash[:error] = "This form has already been built."
      redirect_to rfqforms_path and return
    end

    @rfqform.destroy
    
    respond_to do |format|      
      format.js
    end    
  end

  def create
    if (!current_user.isTLX) then redirect_to rfqforms_path and return end

    @rfqform = Rfqform.new(rfqforms_params)
    @rfqform.date = DateTime.now.to_date

    if @rfqform.save
      flash[:success] = "Created!"
      
      redirect_to @rfqform
    else
      @programs = Part.where("name LIKE 'PA%'").order("name asc")
      @employees = Employee.all.order("name asc")
      render 'new'
    end
  end

  def new
    if (!current_user.isTLX) then redirect_to rfqforms_path and return end

  	@rfqform = Rfqform.new 
    @address = @rfqform.eaus.build 
    @contact = @rfqform.rfqparts.build
    @rfqform.date = DateTime.now.to_date
    @programs = Part.where("name LIKE 'PA%'").order("name asc")
    @employees = Employee.all.order("name asc")
  end  

  def edit
    if (!current_user.isTLX) then redirect_to rfqforms_path and return end

    @rfqform = Rfqform.find(params[:id])
    if (@rfqform.built) then
      flash[:error] = "This form has already been built."
      redirect_to rfqforms_path and return
    end

    @programs = Part.where("name LIKE 'PA%'").order("name asc")
    @employees = Employee.all.order("name asc")
  end  

  def update
    if (!current_user.isTLX) then redirect_to rfqforms_path and return end

    @rfqform = Rfqform.find(params[:id])
    if (@rfqform.built) then
      flash[:error] = "This form has already been built."
      redirect_to rfqforms_path and return
    end

    if @rfqform.update_attributes(rfqforms_params)
      @rfqform.update_attributes(date: DateTime.now.to_date)
      flash[:success] = "Updated"
      redirect_to @rfqform
    else
      @programs = Part.where("name LIKE 'PA%'").order("name asc")
      @employees = Employee.all.order("name asc")
      render 'edit'
    end
  end    

  def build
    if (!current_user.isTLX) then redirect_to rfqforms_path and return end

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
          counter = 1  
          part.rfqpartvendors.reject(&:blank?).each do |vendor|
            quote = Rfqquote.new(
              rfqquote_display_id: counter,
              rfqform_id: @rfqform.id,
              vendor_id: vendor.to_i,
              part_id: part.id)
            counter = counter + 1
            result = nil
            begin
              result = quote.save
            rescue Exception
              (flash[:error] ||= []) << "This form has already been built."
            end
            if (result)  then              
              anysuccess = true;
            else 
              anyfail = true;
            end 

            @rfqform.eaus.each do |eau|
              quote_eau = quote.rfqquote_eaus.build(eau_id: eau.id)
              quote_eau.save
            end           
          end         
        end
      end    
    end

    if (anysuccess)  then
      @rfqform.built = true;
      @rfqform.update_attributes(built: true, date: DateTime.now.to_date)
      
      flash[:success] = "Built!"
      search_id = @rfqform.create_search

      RfqMailer.send_new_rfq(@rfqform).deliver

      redirect_to search_path(search_id)
    else 
      if !anyfail then
        (flash[:error] ||= []) << "There are no vendors in this RFQ."
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
          :qty, :units, :drawing, :drawing_cache, :_destroy,
          rfqpartvendors: []])
    end  

    def GetForms(page)
      if (current_user.isTLX) then
        return Rfqform.paginate(page: page, :order => "id DESC", :per_page => 10 )
      end

      quotes = Rfqquote.where("vendor_id=?", current_user.vendor_id)
      valid_form_ids = quotes.map { |quote| quote.rfqform_id }
      return Rfqform.where(:id => valid_form_ids).paginate(page: page, :order => "id DESC", :per_page => 10 )

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