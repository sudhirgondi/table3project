class InvitesController < ApplicationController
  def index
    @invites = EventAttendant.all
  end

  def new
    @invite = EventAttendant.new
  end

  def create
    @invite = EventAttendant.new(invite_params)
    
    if @invite.save 
      redirect_to event_path(@invite.event_id)
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

    if @invite.update(invite_params)
      redirect_to @invite, notice: 'Invite was successfully updated.'
    else
      render action: 'edit'
    end

  end

  def destroy
    if set_invite.destroy
      redirect_to invites_path, notice: 'Invite deleted.'
    else
      render action: 'index'
    end
  end

  private
    
    # Use callbacks to share common setup or constraints between actions.
    def set_invite
      @invite = EventAttendant.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def invite_params
      params.require(:invite).permit([:user_id, :event_id, :attendee_status]) 
    end

end