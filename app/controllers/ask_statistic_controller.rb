class AskStatisticController < ApplicationController
  protect_from_forgery :except => :add_stats

  def index

  end

  def add_stats
    stats = params[:stats]
    if stats.is_a? Array
      stats.each { |stat|
        if stat.is_a? Hash and stat['id'].is_a? Fixnum
          ask_stat = AskStatistic.find_or_create_by(askId: stat[:id])
          if stat['result']
            ask_stat.rightCount += 1
          else
            ask_stat.wrongCount += 1
          end
          ask_stat.save!
        end
      }
      head 200
    else
      head 400
    end
  end
end
