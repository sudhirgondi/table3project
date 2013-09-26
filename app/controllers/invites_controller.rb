class InvitesController < ApplicationController
  def index
  end

  def new
    @invite = EventAttendant.new
  end

  def create
    @invite = EventAttendant.create(invite_params)
    if @invite.valid?
      redirect_to :back
    end
  end

  def show
  end

  def edit
  end

  def update
    @ea = EventAttendant.find(params[:id])
    @ea.attendee_status = params[:status]
    @ea.save
    redirect_to events_path
  end

  def destroy
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def invite_params
      params.require(:invite).permit(:event_id, :user_id, :attendee_status)
    end
end
