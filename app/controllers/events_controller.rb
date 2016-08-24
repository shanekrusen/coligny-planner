class EventsController < ApplicationController
  before_action :authenticate_user!
  
  def new
    @event = Event.new
  end
  
  def index
    if params[:metonic] == "1"
      @metonic = true
    else
      @metonic = false
    end
    @events = current_user.events.where("day = ? AND month = ? AND year = ? AND metonic = ?", params[:day].to_i, params[:month], params[:year].to_i, @metonic)
  end
  
  def create
    @event = current_user.events.create(event_params)
    if @event.valid?
      redirect_to root_path
    else
      flash[:alert] = "Please fill required fields"
      redirect_to :back
    end
  end
  
  private
  
  def event_params
    params.require(:event).permit(:name, :location, :day, :month, :year, :metonic, :start_time, :end_time)
  end
end
