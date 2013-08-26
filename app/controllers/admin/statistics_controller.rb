class Admin::StatisticsController < ApplicationController

  respond_to :html, :json

  def index
    respond_to do |format|
      format.html do
        @years = Time.now.year.downto(View.minimum(:created_at).year).to_a
        @months = []
        date, oldest_date = Time.now.to_date, View.minimum(:created_at).to_date
        while date.month >= oldest_date.month
          @months << [l(date, format: :monthly), date.strftime('%m/%Y')]
          date -= 1.month
        end
      end
      format.json do
        case params[:type]
        when 'day'
          render json: View.daily_stats(params[:filter_month].split('/')[1], params[:filter_month].split('/')[0], params[:site_id])
        when 'month'
          render json: View.monthly_stats(params[:filter_year], params[:site_id])
        end
      end
    end
  end

end
