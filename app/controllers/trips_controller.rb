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
      @trip.update_departure_time
      redirect_to trip_path(@trip)
    else
      flash[:error] = "Trip creation error"
      render :new
    end
  end

  def create_fake
    @trip = Trip.new(params[:trip])

  end

end