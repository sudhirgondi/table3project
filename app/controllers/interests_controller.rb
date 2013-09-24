class InterestsController < ApplicationController
  def index
    @interests = Interest.all
  end

  def new
    # @interest = Interest.new
    @events = Event.all
    
  end

  def create
    @interest = Interest.new(interest_params)
    if @interest.save 
      redirect_to interest_path(@interest)
    else
      render action: 'new'
    end
  end

  def show
    set_interest
  end

  def edit
    set_interest
  end

  def update
    set_interest

    if @interest.update(interest_params)
      redirect_to @interest, notice: 'Interest was successfully updated.'
    else
      render action: 'edit'
    end

  end

  def destroy
    if set_interest.destroy
      redirect_to interests_path, notice: 'Interest deleted.'
    else
      render action: 'index'
    end
  end

  private
    
    # Use callbacks to share common setup or constraints between actions.
    def set_interest
      @interest = Interest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def interest_params
      params.require(:interest).permit([:name])
    end

end
