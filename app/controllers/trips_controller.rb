class TripsController < ApplicationController
  include SessionHelper
  before_filter :require_login, [:show, :new, :create]


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

  def new_fake
    @trip = Trip.new
  end

  def create_fake
    @trip = Trip.new(params[:trip])
    if @trip.save
      correct_user.trips << @trip
      @trip.format_fake_trip(params[:time2go])
      redirect_to trip_path(@trip)
    else
      flash[:error] = "Trip creation error"
      render :new
    end
  end


   private

   def require_login
     unless logged_in?
       flash[:error] = "You must be logged in to access this section"
       redirect_to root_path # halts request cycle
     end
   end

end
