module ApplicationHelper
  def display_station_name(abbreviation)
    Station.find_by_abbr(abbreviation).name
  end

  def format_time(time)
    time.strftime("%l:%M %P")
  end
end
