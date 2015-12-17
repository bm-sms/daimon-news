ActiveAdmin.register Site do
  permit_params :name, :js_url, :css_url, :fqdn, :tagline, :copyright, :bbs_enabled
end
