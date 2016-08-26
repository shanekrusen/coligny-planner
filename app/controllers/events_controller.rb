class EventsController < ApplicationController
  before_action :authenticate_user!
  
  def new
    @event = Event.new
  end
  
  def destroy
    @event = Event.find(params[:id])
    
    if @event.user != current_user
      return render text: 'Not Allowed', status: :forbidden
    end
    
    @event.destroy
    redirect_to :back
  end
  
  def index
    if params[:metonic] == "1"
      @metonic = true
    else
      @metonic = false
    end
    @all_dependent = current_user.events.where("cycle_dependent = true")
    @all_independent = current_user.events.where("cycle_dependent = false")
  
    @dependent_duration_events = []
    
    @all_dependent.each do |event|
      if (event.date..(event.date + event.duration.days - 1.days)).cover?(Coligny::ColignyDate.new(params[:year].to_i, params[:month], params[:day].to_i, @metonic).to_gregorian_date) && event.duration > 1
        @dependent_duration_events << event
      end
    end
    
    @independent_duration_events = []
    
    @all_independent.each do |event|
      @event_date = Coligny::ColignyDate.new(event.year.to_i, event.month, event.day.to_i, @metonic).to_gregorian_date
      if (@event_date..(@event_date + event.duration.days - 1.days)).cover?(Coligny::ColignyDate.new(params[:year].to_i, params[:month], params[:day].to_i, @metonic).to_gregorian_date) && event.duration > 1
        @independent_duration_events << event
      end
    end
    
    @events = current_user.events.where("day = ? AND month = ? AND year = ? AND cycle_dependent = false", params[:day].to_i, params[:month], params[:year].to_i)
    @dependent_events = current_user.events.where("date = ? AND cycle_dependent = true", Coligny::ColignyDate.new(params[:year].to_i, params[:month], params[:day].to_i, @metonic).to_gregorian_date)
    
    @events = @events.to_a
    @dependent_events = @dependent_events.to_a
    
    @events.delete_if { |event| @independent_duration_events.include?(event) }
    @dependent_events.delete_if { |event| @dependent_duration_events.include?(event) }
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
    params.require(:event).permit(:name, :location, :day, :month, :year, :metonic, :start_time, :end_time, :date, :cycle_dependent, :duration)
  end
end
