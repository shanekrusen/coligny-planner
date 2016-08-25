class StaticPagesController < ApplicationController
  def index
    @dependent_dates = []
    @independent_dates = []
    
    @all_dependent = current_user.events.where("cycle_dependent = true")
    @all_independent = current_user.events.where("cycle_dependent = false")
    
    @all_dependent.each do |event|
      (event.date..(event.date + event.duration - 1)).each do |date|
        @dependent_dates << date
      end
    end
    
    @all_independent.each do |event|
      (0..(event.duration - 1)).each do |date_change|
        if params[:metonic] == "1"
          @push_date = Coligny::ColignyDate.new(event.year.to_i, event.month, event.day, true)
          @push_date.calc_days(date_change)
          @independent_dates << @push_date
        else
          @push_date = Coligny::ColignyDate.new(event.year.to_i, event.month, event.day, false)
          @push_date.calc_days(date_change)
          @independent_dates << @push_date
        end
      end
    end
  end
end
