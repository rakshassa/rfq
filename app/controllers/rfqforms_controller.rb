class RfqformsController < ApplicationController

  def index

    if (!(params[:userid] == nil)) then
      session[:userid] = params[:userid]
      session[:token] = params[:token]
    end

    #logger.info("parm input: " + params[:userid] + " ... " + params[:token])
    #logger.info("session: " + session[:userid] + " ... " + session[:token])

    if (!validate_user()) then redirect_to APP_CONFIG['login_redirect'] and return end

    @rfqforms = GetForms().order('id DESC').paginate(page: params[:page], :per_page => 10 )
    @quotes = GetQuotes(@rfqforms)    
  end	

  def show
    if (!validate_user()) then redirect_to APP_CONFIG['login_redirect'] and return end
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
    if (!validate_user()) then redirect_to APP_CONFIG['login_redirect'] and return end
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
    if (!validate_user()) then redirect_to APP_CONFIG['login_redirect'] and return end
    if (!current_user.isTLX) then redirect_to rfqforms_path and return end

    @rfqform = Rfqform.new(rfqforms_params)
    @rfqform.date = DateTime.now.to_date

    if @rfqform.save
      flash[:success] = "Created!"
      
      redirect_to @rfqform
    else
      prep_edit_variables
      render 'new'
    end
  end

  def new
    if (!validate_user()) then redirect_to APP_CONFIG['login_redirect'] and return end
    if (!current_user.isTLX) then redirect_to rfqforms_path and return end

  	@rfqform = Rfqform.new 
    @address = @rfqform.eaus.build 
    @contact = @rfqform.rfqparts.build
    @rfqform.date = DateTime.now.to_date
    prep_edit_variables
  end  

  def edit
    if (!validate_user()) then redirect_to APP_CONFIG['login_redirect'] and return end
    if (!current_user.isTLX) then redirect_to rfqforms_path and return end

    @rfqform = Rfqform.find(params[:id])
    if (@rfqform.built) then
      flash[:error] = "This form has already been built."
      redirect_to rfqforms_path and return
    end

    prep_edit_variables    
  end  

  def update
    if (!validate_user()) then redirect_to APP_CONFIG['login_redirect'] and return end
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
      prep_edit_variables
      render 'edit'
    end
  end    

  def build
    if (!validate_user()) then redirect_to APP_CONFIG['login_redirect'] and return end
    if (!current_user.isTLX) then redirect_to rfqforms_path and return end

    @rfqform = Rfqform.find(params[:id])
    if (@rfqform.built) then
      flash[:error] = "This form has already been built."
      redirect_to rfqforms_path and return
    end
    
    quotes = @rfqform.build()

    if (quotes.size > 0)  then
      flash[:success] = "Built!"
      search_id = @rfqform.create_search
      
      RfqMailer.send_new_rfq(@rfqform).deliver

      redirect_to search_path(search_id)
    else       
      (flash[:error] ||= []) << "There was a problem building this RFQ."      
      redirect_to rfqforms_path
    end  

  end


  private

    def rfqforms_params
      params.require(:rfqform).permit(:date, :due_date, :release_type, :launch_date,
        :ppap, :req_by, :engineer, :info, :program,

        eaus_attributes: [:id, :value, :_destroy],
        rfqparts_attributes: [:id, :part_number, :revision, 
          :qty, :units, :drawing, :drawing_cache, :_destroy,
          rfqpartvendors: []])
    end  

    def GetForms()
      if (current_user.isTLX) then
        return Rfqform.all
      end

      return Rfqform.all.limit_to_vendor(current_user.vendor_id)

    end

    def GetQuotes(rfqforms)
      quotes = {}
      rfqforms.each do |form|
        if (form.built) then
          quotes[form.id] = form.auth_quotes          
        end
      end

      return quotes      
    end

    def prep_edit_variables
      @programs = Part.programs
      @employees = Employee.active.sorted
    end
end