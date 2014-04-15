class BartTripsController < ApplicationController
  include SessionHelper
  before_filter :require_login, [:show, :new, :create]


  def show
    @bart_trip = BartTrip.find(params[:id])
    render :show
  end

  def new
    @bart_trip = BartTrip.new
  end

  def create
    @bart_trip = BartTrip.new(params[:bart_trip])
    if @bart_trip.save
      correct_user.bart_trips << @bart_trip
      @bart_trip.update_departure_time
      redirect_to bart_trip_path(@bart_trip)
    else
      flash[:error] = "Trip creation error"
      render :new
    end
  end

  def new_fake
    @bart_trip = BartTrip.new
  end

  def create_fake
    @bart_trip = BartTrip.new(params[:bart_trip])
    if @bart_trip.save
      correct_user.bart_trips << @bart_trip
      @bart_trip.format_fake_trip(params[:time2go])
      redirect_to trip_path(@bart_trip)
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
