class TripsController < ApplicationController
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
      redirect_to @trip
    else
      flash[:error] = "Trip creation error"
      render :new
    end
  end
end