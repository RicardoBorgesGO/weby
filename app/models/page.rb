class Page < ActiveRecord::Base
  belongs_to :user, :foreign_key => "author_id"
	belongs_to :repository, :foreign_key => "repository_id"

  has_many :pages_repositories
  has_many :repositories, :through => :pages_repositories

  has_many :sites_pages
  has_many :sites, :through => :sites_pages

  accepts_nested_attributes_for :sites_pages, :allow_destroy => true#, :reject_if => proc { |attributes| attributes['title'].blank? }
  accepts_nested_attributes_for :pages_repositories
end
