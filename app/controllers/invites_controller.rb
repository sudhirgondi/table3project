class InvitesController < ApplicationController
  def index
  end

  def new
    @invite = EventAttendant.new
  end

  def create
    @invite = EventAttendant.create(invite_params)
    @user = User.find(@invite.user_id)

    respond_to do |format|
      if @invite.valid?
        format.html { redirect_to :back }
        format.js { render 'create' }
      end
    end
  end

  def show
    set_invite
  end

  def edit
    set_invite
  end

  def update
    set_invite
    @ea = EventAttendant.find(params[:id])
    @ea.attendee_status = params[:status]
    @ea.save
    redirect_to events_path
  end

  def destroy
  end

  private

    def set_invite
      @invite = EventAttendant.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def invite_params
      params.require(:invite).permit(:event_id, :user_id, :attendee_status)
    end
end
