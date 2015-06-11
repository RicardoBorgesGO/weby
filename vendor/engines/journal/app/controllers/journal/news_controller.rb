module Journal
  class NewsController < Journal::ApplicationController
    layout :choose_layout

    helper_method :sort_column
    before_action :check_current_site

    respond_to :html, :js, :json, :rss

    def index
      @newslist = get_news

      respond_with(@newslist) do |format|
        format.rss { render layout: false, content_type: Mime::XML } # index.rss.builder
        format.atom { render layout: false, content_type: Mime::XML } # index.atom.builder
      end
    end

    def show
      @news = current_site.news.find(params[:id])
      if current_site.extensions.find_by(name: 'journal').settings.updated_at == '1' &&
        (@news.i18ns.first.created_at != @news.i18ns.first.updated_at ||
        current_site.extensions.find_by(name: 'journal').settings.created_at == '0') &&
        !@news.i18ns.first.updated_at.blank?
          @updated_at = l(@news.i18ns.first.updated_at, format: :short)
      end
      raise ActiveRecord::RecordNotFound if !@news.published? && @news.user != current_user
      if request.path != news_path(@news)
        redirect_to news_path(@news), status: :moved_permanently
        return
      end
    end

    private

    def tags
      params[:tags].split(',').map { |tag| tag.mb_chars.downcase.to_s }
    end

    def get_news
      params[:direction] ||= 'desc'
      # Vai ao banco por linha para recuperar
      # tags e locales
      result = Journal::News.where(site_id: current_site).available.
        search(params[:search], params.fetch(:search_type, 1).to_i).
        order(sort_column + ' ' + sort_direction).
        page(params[:page]).per(params[:per_page])

      result = result.tagged_with(tags, any: true) if params[:tags]
      result
    end

    def sort_column
      params[:sort] || 'journal_news.id'
    end

    def check_current_site
      render_404 unless current_site
    end
  end
end
