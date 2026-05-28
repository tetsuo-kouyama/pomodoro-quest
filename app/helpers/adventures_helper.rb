module AdventuresHelper
  def format_adventure_time(time)
    time.strftime("%m/%d %H:%M")
  end

  def format_adventure_clock(time)
    time.strftime("%H:%M")
  end
end
