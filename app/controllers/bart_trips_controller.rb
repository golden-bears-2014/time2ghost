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
    # do we actually expect that save would ever be valid / invalid?
    # I don't see that there is any reason to not merely call
    # current.user.bart_trips.create(params[:bart_trip])
    @bart_trip = BartTrip.new(params[:bart_trip])
    if @bart_trip.save
      current_user.bart_trips << @bart_trip
      # Any reason this isn't part of after_create or something like that?
      # put it on BartTrip?
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

  # hate this.  Why?  Implies your design is bad if you need this.
  def create_fake
    @bart_trip = BartTrip.new(params[:bart_trip])
    if @bart_trip.save
      current_user.bart_trips << @bart_trip
      @bart_trip.format_fake_trip(params[:time2go])
      redirect_to bart_trip_path(@bart_trip)
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
