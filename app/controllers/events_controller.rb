class EventsController < ApplicationController
  def index
    # events created by this user
    @my_events = User.find(current_user.id).event_attendants.where('owner = 1')

    # events this user has joined
    @joined_events = User.find(current_user.id).event_attendants.where('attendee_status = 3 and owner IS NULL')
 
    # events this user is invited to
    # @invited_to__events = User.find(current_user.id).event_attendants.where('owner = 0 and attendee_status = 0').includes(:event)
    @invited_to_events = User.find(current_user.id).event_attendants.where('attendee_status = 0')

  end

  def new
    @event = Event.new
  end

  def create
    @event = User.find(current_user.id).events.create(event_params)
    # @event.user_id = current_user.id
    if @event.valid?
      @ea = @event.event_attendants.last
      @ea.owner = 1
      @ea.attendee_status = 3
      @ea.save
      redirect_to event_path(@event)
    else
      render action: 'new'
    end
  end

  def show
    set_event
    @interest_name = Interest.find(@event.interest_id).name

    # @owner = @event.users.where('owner = 1').first
    @owner = @event.users.first
    @post = @event.posts.new
    @posts = @event.posts.order('posts.created_at DESC')

    @invited_users = User.joins(:event_attendants).where('attendee_status = 0').where('event_id = ?', @event.id).order('first_name ASC')
    @notgoing_users = User.joins(:event_attendants).where('attendee_status = 1').where('event_id = ?', @event.id).order('first_name ASC')
    @maybe_users = User.joins(:event_attendants).where('attendee_status = 2').where('event_id = ?', @event.id).order('first_name ASC')
    @going_users = User.joins(:event_attendants).where('attendee_status = 3').where('event_id = ?', @event.id).order('first_name ASC')

    @interested_user_ids = User.joins(:user_interests).where("interest_id = ?", @event.interest_id).pluck(:id)
    @invitation_sent_user_ids = EventAttendant.where("event_id = ?", @event.id).pluck(:user_id)

    # str = @interested_user_ids.join(",")
    # @interested_uninvited = EventAttendant.includes(:user).where("user_id not in (#{str})")
    @interested_uninvited_ids = @interested_user_ids - @invitation_sent_user_ids

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
