class InterestsController < ApplicationController
  def index
    @interests = Interest.all
  end

  def new
    @interest = Interest.new
  end

  def create
    # @interest = Interest.new(interest_params)
    # if @interest.save 
    #   redirect_to interest_path(@interest)
    # else
    #   render action: 'new'
    # end

    interest_info = Interest.find(params[:interest_id])
    interest = User.find(session[:user_id]).interests.push(interest_info)
    redirect_to :back
  end

  def show
    set_interest
    @interest_users = @interest.users
    @interest_events = @interest.events
    @i_id = @interest.id 
    if signed_in?
      @invited_to_events = User.find(current_user.id).events.where("interest_id = #{@i_id} and attendee_status = 0").pluck(:id)
      @joined_events = User.find(current_user.id).events.where("interest_id = #{@i_id} and attendee_status = 3").pluck(:id)
      # @event_attendants = Event.find(25).event_attendants.where("user_id = #{current_user.id} and attendee_status = 0")
    end

    @events = @interest.events
    @json = @events.to_gmaps4rails
  end
  def gmaps4rails_infowindow
      "<h1>hi!</h1>"
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
    User.find(current_user.id).user_interests.where("interest_id=#{params[:interest_id]}").first.destroy
    redirect_to :back
  end

  private
    
    # Use callbacks to share common setup or constraints between actions.
    def set_interest
      @interest = Interest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def interest_params
      params.require(:interest).permit([:name], [:int_id])
    end

end
