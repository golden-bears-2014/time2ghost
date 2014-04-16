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
      # OK a controller doesn't need to know about `update_departure_time`.
      # This should live on the BartTrip.  I recommend after_save or
      # after_create.  Basically make this calculation eagerly on any created
      # BartTrip.
      current_user.bart_trips << @bart_trip
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

  # Be sure to kill this stuff on your 'demoable' branch today.
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

  # fix your indenting  - the style below is Rails contributor guideline style.
  # but beware!  just like the parentheses holy wars, this is one of those
  # things that developers go nuts about.
  private

    def require_login
      unless logged_in?
        flash[:error] = "You must be logged in to access this section"
        redirect_to root_path # halts request cycle
      end
    end

end
