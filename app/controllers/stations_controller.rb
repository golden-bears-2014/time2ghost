class StationsController < ApplicationController

  def index
    respond_to do |format|
      format.json { render json: Station.all }
    end
  end

end