# Consertando erros da migração
def treat(obj,field)
  dic = {original: 'o', little: 'l', medium: 'm', mini: 'i', thumb: 't'}
  if obj and obj.send(field)
#    obj.send(field).gsub(/(['"])\/uploads\/([0-9]+)\/o\//){|x| "#{$1}/uploads/#{obj.site_id}/" if $2 != obj.site_id}

    obj.send(field).gsub(/\/uploads\/([0-9]+)\/(original|little|thumb|medium|mini)_/){|x| "/up/#{$1}/#{dic[$2.to_sym]}/"}
  end
end

def treat_url(obj,field)
  if obj
    obj.send(field).gsub(/\/pages\/([0-9]+)/){|x| "/pages/#{$1}/"}
  end
end

Page.all.each do |page|
  page.url = treat(page, :url)
    page.save
end
Page::I18ns.all.each do |i18n|
  i18n.text = treat(i18n, :text)
  i18n.summary = treat(i18n, :summary)
    i18n.save
end
Sticker::Banner.all.each do |banner|
  banner.url = treat(banner, :url)
    banner.save
end
MenuItem.all.each do |menu|
  menu.url = treat(menu, :url)
    menu.save
end
    page.save