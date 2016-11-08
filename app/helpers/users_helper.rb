module UsersHelper
  # Returns an hash that contains the sites and the roles that an user owns
  # Eg: { 'Math' => [role1, role2] }
  def sites_with_roles
    sites = {}
    @user.roles.order(:site_id).each do |r|
      role_site_title = r.site.try(:title)
      (sites[role_site_title] ||= []) << r
    end
    sites
  end

  def notifications_icon_admin
    user = User.find(current_user.id)
    unread = user.unread_notifications_array
    if unread.empty?
      link_to main_app.notifications_url(subdomain: current_site), title: t('notifications.index.notifications') do
        "<i class=\"fa fa-envelope-o\"></i>".html_safe
      end
    else
      link_to main_app.notifications_url(subdomain: current_site) do
        content_tag(:span, title: t('notifications.index.notifications')) do
          "<i class=\"fa fa-envelope-o\"></i><span class=\"label label-success\">#{unread.size}</span>".html_safe
        end
      end
    end
  end

  def notifications_icon
    user = User.find(current_user.id)
    unread = user.unread_notifications_array
    if unread.empty?
      link_to main_app.notifications_url(subdomain: current_site), class: 'label label-default', title: t('notifications.index.notifications') do
        "<span class=\"glyphicon glyphicon-envelope\"></span>".html_safe
      end
    else
      link_to main_app.notifications_url(subdomain: current_site) do
        content_tag(:span, class: 'label label-warning', title: t('notifications.index.notifications')) do
          "<span class=\"glyphicon glyphicon-envelope\"></span> #{unread.size}".html_safe
        end
      end
    end
  end
end
