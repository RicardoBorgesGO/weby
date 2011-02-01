class PagesController < ApplicationController
  layout :choose_layout
  before_filter :require_user
  before_filter :check_authorization

  respond_to :html, :xml, :js

  def index 
    params[:type] ||= 'News'
 
    @pages = Object.const_get(params[:type]).where(["site_id = ?", @site.id]).all
    respond_with(@pages)
  end

  def show
    @page = Page.find(params[:id])
    #@page = Object.const_get(params[:type]).find(params[:id]) if params[:type]
    params[:type] ||= @page.type
    respond_with(@page)
  end

  def new
    params[:type] ||= 'News'

    @repositories = Repository.where(["site_id = ? AND archive_content_type LIKE ?", @site.id, "image%"]).paginate :page => params[:page], :order => 'created_at DESC', :per_page => 4 
    @page = Object.const_get(params[:type].capitalize).new
    @page.sites_pages.build
    respond_with(@page)
  end

  def edit
    @repositories = Repository.where(["site_id = ? AND archive_content_type LIKE ?", @site.id, "image%"]).paginate :page => params[:page], :order => 'created_at DESC', :per_page => 4 
    @page = Page.find(params[:id])
    params[:type] ||= @page.type
  end

  def create
    @page = Object.const_get(params[:type]).new(params[params[:type].downcase.to_s])
    @page.save
    respond_with(@page, :location => site_pages_path(:type => params[:type]))
  end

  def update
    #@page = Object.const_get(params[:type]).find(params[:id])
    @page = Page.find(params[:id])
    @page.update_attributes(params[@page.class.name.underscore])
    #respond_with(@page, :location => site_pages_path(:type => params[:type]))
    redirect_to site_page_path(@site, @page)
  end

  def destroy
    @page = Page.find(params[:id])
    # deleta todas as relacoes da pagina com os sites
    SitesPage.find(@page.sites_pages).each{ |p| p.destroy }
    @page.destroy
    redirect_to(:back)
  end
end
