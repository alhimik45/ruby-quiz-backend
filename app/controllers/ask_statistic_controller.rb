class AskStatisticController < ApplicationController
  protect_from_forgery :except => :add_stats

  before_filter :cors_preflight_check
  after_filter :cors_set_access_control_headers

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = 'http://railshurts.com'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization, Token'
    headers['Access-Control-Max-Age'] = "1728000"
  end

  def cors_preflight_check
    if request.method == 'OPTIONS'
      headers['Access-Control-Allow-Origin'] = 'http://railshurts.com'
      headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
      headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version, Token, Content-Type'
      headers['Access-Control-Max-Age'] = '1728000'

      render :text => '', :content_type => 'text/plain'
    end
  end

  def index

  end

  def stats
    result = AskStatistic.order(:askId).all.map { |stat|
      {id: stat.askId,
       right: stat.rightCount,
       wrong: stat.wrongCount}
    }
    render json: result
  end

  def add_stats
    stats = params[:stats]
    if stats.is_a? Array
      asks = {}
      stats.each { |stat|
        if stat.is_a? Hash and stat['id'].is_a? Fixnum
          ask_stat = asks[stat[:id]] || AskStatistic.find_or_create_by(askId: stat[:id])
          if stat['result']
            ask_stat.rightCount += 1
          else
            ask_stat.wrongCount += 1
          end
          asks[stat[:id]] = ask_stat
        end
      }
      ActiveRecord::Base.transaction do
        asks.values.map(&:save)
      end
      head 200
    else
      head 400
    end
  end
end
