class EventsController < ApplicationController
  def index
    @events = Event.all
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.owner_user_id = current_user.id
    if @event.save 
      redirect_to event_path(@event)
    else
      render action: 'new'
    end
  end

  def show
    set_event
    @owner = User.find(@event.owner_user_id)
    @post = @event.posts.new
    @posts = @event.posts.order('posts.created_at DESC')
  end

  def edit
    set_event
  end

  def update
    set_event

    if @event.update(event_params)
      redirect_to @event, notice: 'Event was successfully updated.'
    else
      render action: 'edit'
    end

  end

  def destroy
    if set_event.destroy
      redirect_to events_path, notice: 'Event deleted.'
    else
      render action: 'index'
    end
  end

  private
    
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit([:name, :description, :start_date, :end_date, :start_time, :end_time, :location, :address, :city, :state, :zip_code, :owner_user_id, :interest_id])
    end

end
