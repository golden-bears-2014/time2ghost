class TripsController < ApplicationController
include SessionHelper

  def show
    @trip = Trip.find(params[:id])
    render :show
  end

  def new
    @trip = Trip.new
  end

  def create
    @trip = Trip.new(params[:trip])
    if @trip.save
      correct_user.trips << @trip
      #  This method....i would first expect that it would take an argument of
      #  the time to which the trip is being updated.  Or, at the least it
      #  would have a ! to show me that internally it was going to do some
      #  calculation.
      #
      #  But then I opened up the implementation and I wanted to jump out the
      #  window.
      @trip.update_departure_time
      redirect_to trip_path(@trip)
    else
      flash[:error] = "Trip creation error"
      render :new
    end
  end
end
